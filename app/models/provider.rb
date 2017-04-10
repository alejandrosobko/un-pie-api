class Provider < ApplicationRecord
  has_many :products

  validates_presence_of :name, message: 'debe existir'
  validates_uniqueness_of :name, message: 'debe ser único'
  audited
end
