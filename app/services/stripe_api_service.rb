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

    def retrieve_session(session_id)
      Stripe::Checkout::Session.retrieve(session_id)
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

    def cancel_subscription(subsciption_id)
      Stripe::Subscription.cancel(subsciption_id)
    end

    def create_payment_method_session(customer_id, plan: "uvo-ai-plan")
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        mode: 'setup',
        ui_mode: 'embedded',
        customer: customer_id,
        return_url: ENV.fetch("PAYMENT_METHOD_REDIRECT_URL")
      })

      {clientSecret: session.client_secret}
    end
  end
end
