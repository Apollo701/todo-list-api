class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  INVALID_EMAIL_MESSAGE = 'Emails must consist of a normal email format'
  has_secure_password
  has_many :todos, dependent: :destroy

  before_save :downcase_email
  validates :password, length: { in: 6..20 }
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: VALID_EMAIL_REGEX,
                              message: INVALID_EMAIL_MESSAGE }

  def as_json_with_todos
    { user:  as_json.merge({ todos: todos.as_json }) }
  end

  private

  def downcase_email
    email.downcase!
  end
end
