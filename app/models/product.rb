class Product < ApplicationRecord
  belongs_to :provider, autosave: true

  validates_presence_of :brand, message: 'debe existir'
  validates_presence_of :provider, message: 'debe existir'
  audited
end
