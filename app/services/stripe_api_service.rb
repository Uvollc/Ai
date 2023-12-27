class StripeApiService
  class << self
    def execute_subscription(customer, plan: "uvo-ai-plan")
      Stripe::Subscription.create({
        customer: customer.id,
        items: [{price: plan}]
      })
    end

    def create_checkout_session(customer, plan: "uvo-ai-plan")
      session = Stripe::Checkout::Session.create({
        ui_mode: 'embedded',
        customer: customer.id,
        line_items: [{
          price: plan,
          quantity: 1,
        }],
        mode: 'subscription',
        return_url: ENV.fetch("STRIPE_REDIRECT_URL"),
      })

      {clientSecret: session.client_secret}
    end

    def list_invoices(customer_id)
      Stripe::Invoice.list({customer: customer_id})
    end

    def find_or_create_customer(customer)
      if customer.stripe_customer_id.present?
        stripe_customer = Stripe::Customer.retrieve({ id: customer.stripe_customer_id })
      else
        stripe_customer = Stripe::Customer.create({
          email: customer.email,
          name: customer.full_name,
        })
      end

      stripe_customer
    end

    def list_payment_methods(customer_id)
      Stripe::Customer.list_payment_methods(customer_id)
    end
  end
end