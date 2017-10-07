class SessionsController < ApplicationController
  include SessionHelper
  before_action :require_login
  skip_before_action :require_login, only: [:create], raise: false

  def create
    if user = User.valid_login?(params[:email], params[:password])
      user.regenerate_token
      render json: { token: user.token }
    else
      render_unauthorized("There is an issue with your email or password")
    end
  end

  def destroy
    current_user.invalidate_token
    head :ok
  end
end
