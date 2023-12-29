class UserSerializer < BaseSerializer
  set_type :user

  attributes :id, :email, :first_name, :last_name, :phone, :payment_status
end
