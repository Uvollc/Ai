class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_chats, dependent: :destroy

  PAYMENT_STATUSES = { pending: "pending", paid: "paid" }.freeze
  enum payment_status: PAYMENT_STATUSES

  def create_chat
    chat_id = OpenaiApiService.create_chat
    chat = user_chats.create(chat_id: chat_id)

    chat
  end

  def valid_subscription?
    return false if self.payment_status == PAYMENT_STATUSES[:pending]

    true
  end
end
