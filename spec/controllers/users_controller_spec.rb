require 'rails_helper'

describe UsersController, type: :controller do
  describe 'POST Create' do
    let!(:user_params) do
      {
        email: 'apollo@gmail.com',
        password: '12345'
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

  describe 'PUT Update' do
    context 'authenticated' do
      let!(:user) { User.create(email: 'apollo@gmail.com', password: '12345') }
      let!(:completed_params) { { task: 'create app', completed: true, user_id: user.id }.as_json }

      before { authenticate(user) }

      it 'updates the user from the provided arguments' do
        updated_user_params = {
          email: 'notapollo@gmail.com',
          password: '54321',
        }.as_json
        expect{ put :update, params: { id: user.id, user: updated_user_params } }
          .to change { user.reload.email }.to(updated_user_params['email'])
      end

      it 'returns the updated user' do
        updated_user_params = {
          email: 'notapollo@gmail.com',
          password: '54321',
        }.as_json

        put :update, params: { id: user.id, user: updated_user_params }
        user_json = JSON.parse(response.body)
        expect(updated_user_params['email']).to eq user_json['email']
      end
    end
  end
end
