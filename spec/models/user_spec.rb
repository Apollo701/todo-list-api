require 'rails_helper'

describe User, type: :model do
  it "downcases emails before saving to the db" do
    email = "BATMAN@bruce.com"
    user_params = {
      email: email,
      password: "IAMTHEKNIGHT"
    }
    user = User.create(user_params)
    expect(user.email)
      .to eq email.downcase
  end
end
