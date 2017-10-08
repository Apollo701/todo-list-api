require 'rails_helper'

describe SessionsController, type: :controller do
  describe 'POST /login' do
    let(:valid_user_params) {{
      email: 'apollo@gmail.com',
      password: '12345'
    }}
    before {
      User.create! valid_user_params
    }
    it 'renders json of the user token' do
      post :create, format: :json, params: valid_user_params
      keys = JSON.parse(response.body).keys
      expect(keys).to eq ['token']
    end

    it 'renders login errors' do
      post :create, format: :json, params: {}
      errors = JSON.parse(response.body).dig('errors')
      expect(errors.length.zero?).to eq false
    end
  end

  describe 'DELETE /logout' do
    it 'returns head :ok' do
      user = instance_double('User')
      expect(user).to receive(:invalidate_token)
      allow(controller).to receive(:authenticate_token).and_return user
      valid_session = { token: 'randomToken' }
      delete :destroy, format: :json, params: { id: user.to_param }, session: valid_session
      expect(response.status).to eq 200
    end
  end
end
