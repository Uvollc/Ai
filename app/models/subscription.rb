class Subscription < ApplicationRecord
  belongs_to :user

  STATUSES = { pending: "pending", active: "active", failed: "failed", canceled: "canceled" }.freeze
  enum status: STATUSES
end
