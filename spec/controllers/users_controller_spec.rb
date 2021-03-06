require 'rails_helper'

describe UsersController, type: :controller do
  describe 'POST Create' do
    let!(:user_params) do
      {
        email: 'apollo@gmail.com',
        password: '123456'
      }.as_json
    end

    it 'creates a new user' do
      expect { post :create, params: { user: user_params } }
        .to change { User.count}.by 1
    end

    it 'returns json of the new user' do
       post :create, params: { user: user_params }
       user_json = JSON.parse(response.body)
       expect(user_params['email']).to eq user_json['email']
    end
  end

  describe 'GET Show' do
    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }
      let!(:todo_params) { { task: 'create app', completed: false }.as_json }

      before {
        authenticate(user)
        user.todos.create(todo_params)
        get :show, params: { id: user.id }
      }

      it 'gets gets json with the users email' do
        user_json = JSON.parse(response.body)
        expect(user_json.dig('user', 'email')).to match user.email
      end

      it "gets json matching todo id's" do
        user_json = JSON.parse(response.body)
        todos_json = user_json.dig('user', 'todos')
        todo_json_id = todos_json.first.dig('id')
        todo_id = user.todos.first.id
        expect(todo_json_id).to eq todo_id
      end

      it 'gets json matching todo task' do
        user_json = JSON.parse(response.body)
        todos_json = user_json.dig('user', 'todos')
        todo_json_task = todos_json.first.dig('task')
        todo_task = user.todos.first.task
        expect(todo_json_task).to eq todo_task
      end
    end
  end

  describe 'PUT Update' do
    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }
      let!(:completed_params) { { task: 'create app', completed: true }.as_json }

      before { authenticate(user) }

      it 'updates the user from the provided arguments' do
        updated_user_params = {
          email: 'notapollo@gmail.com',
          password: '654321',
        }.as_json
        expect{ put :update, params: { id: user.id, user: updated_user_params } }
          .to change { user.reload.email }.to(updated_user_params['email'])
      end

      it 'returns the updated user' do
        updated_user_params = {
          email: 'notapollo@gmail.com',
          password: '654321',
        }.as_json

        put :update, params: { id: user.id, user: updated_user_params }
        user_json = JSON.parse(response.body)
        expect(updated_user_params['email']).to eq user_json['email']
      end
    end
  end

  describe 'DELETE destroy' do
    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '123456') }

      before { authenticate(user) }

      it 'destroys the user' do
        expect{ delete :destroy, params: { id: user.id } }
          .to change { User.count }.by(-1)
      end
    end
  end
end
