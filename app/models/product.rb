class Product < ApplicationRecord
  has_many :stocks
  has_many :providers, through: :stocks

  validates_presence_of :brand
  audited

  def amount
    Stock.where(product_id: id).collect(&:amount).inject(:+)
  end

end
