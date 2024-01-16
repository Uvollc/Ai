class Device < ApplicationRecord
  has_one :chat, as: :chatable
end
