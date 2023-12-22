class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :chats, as: :chatable, dependent: :destroy

  PAYMENT_STATUSES = { pending: "pending", paid: "paid" }.freeze
  enum payment_status: PAYMENT_STATUSES

  def valid_subscription?
    return false if (self.payment_status == PAYMENT_STATUSES[:pending] && chats.last.reached_message_limit?)

    true
  end
end
