class TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy]
  before_action :authenticate_user

  def create
    @todo = Todo.new(todo_params.merge({ completed: false }))

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
  end

  private

  def set_todo
    @todo = Todo.find(todo_id)
  end

  def todo_id
    params.dig(:id)
  end

  def user_id
    params.dig(:todo, :user_id)
  end

  def todo_params
    params.require(:todo).permit(:task, :completed, :user_id)
  end
end
