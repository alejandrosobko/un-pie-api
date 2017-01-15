class Product < ApplicationRecord
  belongs_to :provider

  validates_presence_of :provider, message: 'debe existir'
end
