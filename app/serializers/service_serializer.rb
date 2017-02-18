class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost, :payment_date
end
