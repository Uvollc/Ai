class Subscription < ApplicationRecord
  belongs_to :user

  before_destroy -> (subsciption) { StripeApiService.cancel_subscription(subsciption.charge_id) }
end
