require 'rails_helper'

describe SessionsController, type: :controller do
  describe 'POST /login' do
    let(:valid_user_params) {{
      email: 'apollo@gmail.com',
      password: '12345'
    }}
    it 'renders json of the user token' do
      User.create(valid_user_params)
      post :create, format: :json, params: valid_user_params
      expect(JSON.parse(response.body).keys).to eq ['token']
    end

    it 'renders login errors' do
      User.create(valid_user_params)
      post :create, format: :json, params: {}
      expect(response).not_to be_nil
      expect(JSON.parse(response.body).dig('errors').length.zero?).to eq false
    end
  end

  describe 'DELETE /logout' do
    it 'returns head :ok' do
      user_token = double(:token, invalidate_token: true)
      allow(controller).to receive(:authenticate_token).and_return user_token
      delete :destroy, format: :json
      expect(response.status).to eq 200
    end
  end
end
