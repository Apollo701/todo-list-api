require 'rails_helper'

describe TodosController, type: :controller do
  describe 'POST todos/create' do
    context 'not authenticated' do
      it 'returns an error message' do
        post :create, params: { todo: {} }
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }
      let!(:todo_params) { { task: 'create app' }.as_json }

      before { authenticate(user) }

      it 'returns a todo json object' do
        post :create, params: { todo: todo_params }
        todo_json = JSON.parse(response.body)
        todo_params.each_key do |key|
          expect(todo_json[key]).to eq todo_params[key]
        end
      end

      it 'creates a new todo for the given user' do
        expect{ post :create, params: { todo: todo_params } }
          .to change { user.todos.count }.by(1)
      end

      it 'assigns a new todo as not completed' do
        post :create, params: { todo: todo_params }
        todo_id = JSON.parse(response.body).dig('id')
        todo = Todo.find(todo_id)
        expect(todo).not_to be_completed
      end
    end
  end

  describe 'PUT todo/:id/update' do
    context 'not authenticated' do
      it 'returns an error message' do
        post :create, params: { todo: {} }
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }
      let!(:todo_params) { { task: 'create app', user_id: user.id }.as_json }
      let!(:completed_params) { { task: 'create app', completed: true, user_id: user.id }.as_json }

      before { authenticate(user) }

      it 'updates the todo from the provided arguments' do
        todo = user.todos.create(todo_params)
        completed_params = {
          task: 'create app',
          completed: true,
          user_id: user.id
        }.as_json

        expect{ put :update, params: { id: todo.id, todo: completed_params } }
          .to change { todo.reload.completed }.to(true)
      end

      it 'returns the updated todo' do

        todo = user.todos.create(todo_params)
        completed_params = {
          task: 'create app',
          completed: true,
          user_id: user.id
        }.as_json

        put :update, params: { id: todo.id, todo: completed_params }
        todo_json = JSON.parse(response.body)
        completed_params.each_key do |key|
          expect(todo_json[key]).to eq completed_params[key]
        end
      end
    end
  end

  describe 'DELETE todo/:id/destroy' do
    context 'not authenticated' do
      it 'returns an error message' do
        post :create, params: { todo: {} }
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }
      let!(:todo_params) { { task: 'create app', user_id: user.id }.as_json }

      before { authenticate(user) }

      it 'destroys a todo for the given user' do
        todo = user.todos.create(todo_params)
        expect{ delete :destroy, params: { id: todo.id } }
          .to change { Todo.count }.by(-1)
      end
    end
  end
end
