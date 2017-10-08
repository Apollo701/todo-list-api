require 'rails_helper'

describe TodosController, type: :controller do
    let(:valid_user_params) do
      { email: "apollo@gmail.com", name: 'Jason', password: '12345' }
    end

    let(:user) { User.create(valid_user_params) }

    let(:todo_params) do
      {
        task: 'Create an app',
        completed: false,
        user_id: user.id
      }
    end

  describe 'POST todos/create' do
    it 'returns a todo json object' do
      post :create, format: :json, params: { todo: todo_params }
      todo_response = JSON.parse(response.body)['todo']
      todo = Todo.new(todo_response)
      expect(todo).to eq user.todos.first
    end

    it 'creates a new todo for the given user' do
      expect{
        post :create, format: :json, params: { todo: todo_params }
      }.to change{ user.todos.count }.by 1
    end
  end

  describe 'PUT todo/:id/update' do
  end

  describe 'DELETE todo/:id/destroy' do
    xit 'destroys a todo for the given user' do
      todo = user.todos.create(todo_params)
      expect {
        delete :destroy, format: :json, params: { id: todo.id }, session: {}
      }.to change{ user.todos.count }.by(-1)
    end
  end
end
