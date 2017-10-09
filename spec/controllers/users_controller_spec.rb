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
end
