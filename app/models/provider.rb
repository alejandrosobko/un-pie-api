class Provider < ApplicationRecord
  has_many :purchase_orders
  has_many :products, through: :purchase_orders

  validates_presence_of :name, message: 'debe existir'
  validates_uniqueness_of :name, message: 'debe ser único'
end
