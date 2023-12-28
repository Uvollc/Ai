class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :chats, as: :chatable, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  # has_many :devices, dependent: :destroy

  PAYMENT_STATUSES = { pending: "pending", paid: "paid" }.freeze
  enum payment_status: PAYMENT_STATUSES

  def valid_subscription?
    return false if (self.payment_status == PAYMENT_STATUSES[:pending] && chats&.last&.reached_message_limit?)

    true
  end

  def assign_public_chat(device_token)
    device = Device.includes(:chat).find_by(device_token: device_token)
    return unless device && device.chat

    device.chat.update(chatable: self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
