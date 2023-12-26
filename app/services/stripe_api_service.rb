class StripeApiService
  class << self
    def execute_subscription(customer, plan: "uvo-ai-plan")
      Stripe::Subscription.create({
        customer: customer.id,
        items: [{price: plan}]
      })
    end

    def list_invoices(customer_id)
      Stripe::Invoice.list({customer: customer_id})
    end

    def find_or_create_customer(customer, card_token)
      if customer.stripe_customer_id.present?
        stripe_customer = Stripe::Customer.retrieve({ id: customer.stripe_customer_id })
        stripe_customer = Stripe::Customer.update(stripe_customer.id, { source: card_token}) if stripe_customer
      else
        stripe_customer = Stripe::Customer.create({
          email: customer.email,
          name: customer.full_name,
          source: card_token
        })
      end

      stripe_customer
    end

    def list_payment_methods(customer_id)
      Stripe::Customer.list_payment_methods(customer_id)
    end
  end
end
