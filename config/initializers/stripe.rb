if Rails.env == 'production'
  Rails.configuration.stripe = {
    :publishable_key => ENV["STRIPE_LIVE_PUBLISHABLE_KEY"],
    :secret_key      => ENV["STRIPE_LIVE_SECRET_KEY"]
  }
else
  Rails.configuration.stripe = {
    :publishable_key => ENV["STRIPE_PUBLISHABLE_KEY"],
    :secret_key      => ENV["STRIPE_SECRET_KEY"]
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
