class TodosController < ApplicationController
  def create
    if user = User.find(user_id)
      todo = user.todos.create(todo_params)
    end
    render json: { todo: todo }
  end

  def update
  end

  def destroy
  end

  private

  def user_id
    params.dig(:todo, :user_id)
  end

  def todo_params
    params.require(:todo).permit(:user_id, :task, :completed)
  end
end
