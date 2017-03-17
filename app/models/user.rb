class User < ApplicationRecord
  include BCrypt

  validates_presence_of :name
  validates_presence_of :surname
  validates :email, presence: true, uniqueness: true, format: {with:  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i}
  validates_presence_of :password
  validate :strong_password

  before_save :hash_password

  audited

  private

  def strong_password
    unless /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x.match(self.password)
      errors.add(:password, 'password is not strong')
    end
  end

  def hash_password
    self.password = Password.create(self.password)
  end

end
