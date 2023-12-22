class Device < ApplicationRecord
  has_one :chat, as: :chatable, dependent: :destroy
end
