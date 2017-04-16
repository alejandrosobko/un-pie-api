class Provider < ApplicationRecord
  has_many :stocks
  has_many :products, through: :stocks

  validates_presence_of :name
  validates_uniqueness_of :name
  audited

end
