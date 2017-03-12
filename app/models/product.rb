class Product < ApplicationRecord
  has_many :purchase_orders
  has_many :providers, through: :purchase_orders

  validates_presence_of :brand, message: 'debe existir'
end
