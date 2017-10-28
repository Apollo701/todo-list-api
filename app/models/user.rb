class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 6..20 }
  before_save :downcase_email

  private

  def downcase_email
    self.email.downcase!
  end
end
