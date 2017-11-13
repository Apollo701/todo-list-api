class TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy]
  before_action :authenticate_user

  def create
    @todo = current_user.todos.build(todo_params.merge({ completed: false }))

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
    @todo = Todo.find(params.dig(:id))
  end

  def todo_params
    params.require(:todo).permit(:task, :completed)
  end
end
