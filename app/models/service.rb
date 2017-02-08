class Service < ApplicationRecord
  validates_presence_of :name, :payment_date, :due_date
  validate :validate_dates

  private

  def validate_dates
    if due_date.present? && payment_date.present? && due_date <= payment_date
      errors[:base] << 'La fecha de vencimiento debe ser posterior a la fecha de pago'
    end
  end

end
