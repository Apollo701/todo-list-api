class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end
end
