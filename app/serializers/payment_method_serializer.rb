class PaymentMethodSerializer < BaseSerializer
  attributes :id, :last_digits, :brand, :status, :expiry, :stripe_method_id
end
