class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 6..20 }
  before_save :downcase_email

  def as_json_with_todos
    as_json.merge({ todos: todos.as_json })
  end

  private

  def downcase_email
    self.email.downcase!
  end
end
