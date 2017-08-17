class Product < ApplicationRecord
  belongs_to :provider, autosave: true
  has_many :purchase_orders, dependent: :destroy

  validates_presence_of :brand, message: 'debe existir'
  validates_presence_of :provider, message: 'debe existir', on: :create
  audited
end
