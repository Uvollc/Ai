class UserSerializer < BaseSerializer
  set_type :user

  attributes :id, :email, :first_name, :last_name, :phone, :payment_status
  attribute :avatar do |obj|
    obj&.avatar&.url
  end
end
