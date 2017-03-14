class Service < ApplicationRecord
  validates_presence_of :name, :payment_date
  audited

end
