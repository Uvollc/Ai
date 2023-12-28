class PaymentMethodSerializer < BaseSerializer
  attributes :id, :last_digits, :brand, :status, :expiry
end
