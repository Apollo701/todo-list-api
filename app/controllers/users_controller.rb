class UsersController < ApplicationController
  before_action :authenticate_user
  skip_before_action :authenticate_user, only: [:create]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: current_user.as_json_with_todos
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
  end

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end
end
