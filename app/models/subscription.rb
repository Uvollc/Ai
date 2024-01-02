class Subscription < ApplicationRecord
  belongs_to :user

  before_destroy -> (subscription) { StripeApiService.cancel_subscription(subscription.charge_id) unless subscription.status == 'canceled' }
end
