require 'rails_helper'

describe User, type: :model do
  describe '#invalidate_token' do
    it "update's a users login token to nil" do
      user = User.create(email: 'apollo@gmail.com', password: '12345')
      expect{ user.invalidate_token }
        .to change{ user.reload.token }.to nil
    end
  end
  describe '.valid_login?' do
    it 'returns the user if valid' do
      user = User.create(email: 'apollo@gmail.com', password: '12345')
      expect(described_class.valid_login?(user.email, user.password))
        .to eq user
    end
    it 'returns null if invalid' do
      expect(described_class.valid_login?('', ''))
        .to eq nil
    end
  end
end
