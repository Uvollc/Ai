class WebhooksController < ApiController
  def create
    webhook_secret = ENV.fetch('STRIPE_WEBOOKS_SECRET')
    payload = request.body.read
    if !webhook_secret.empty?
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      puts "sig_header = #{sig_header}"
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        puts '⚠️  Webhook signature verification failed.'
        status 400
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end
    # Get the type of webhook event sent - used to check the status of PaymentIntents.
    event_type = event['type']
    data = event['data']
    data_object = data['object']

    case event.type
    when 'payment_method.attached'
      payment_method = PaymentMethod.create(
        user: get_user(data_object.customer),
        stripe_method_id: data_object.id,
        brand: data_object.card.brand,
        last_digits: data_object.last4,
        expiry: "#{data_object.exp_month}/#{data_object.exp_year}")

      puts "Payment Method attached: #{event.id}, payment method: #{payment_method.id}"
    when 'checkout.session.completed'
      user = get_user(data_object.customer)
      user.update(payment_status: User::PAYMENT_STATUSES[:paid])

      puts "Checkout session completed: #{event.id}, user_status: #{user.payment_status}"
    when 'customer.subscription.created'
      subsciption = Subscription.create(
        user: get_user(data_object.customer),
        status: data_object.status,
        charge_id: data_object.id)

      puts "Subscription created-> event: #{event.id}, subscription: #{subsciption.id}"
    when 'customer.subscription.updated', 'customer.subscription.deleted', 'customer.subscription.paused'
      subsciption = Subscription.find_by(charge_id: data_object.id)
      subsciption.update(status: data_object.status)

      puts "Subscription updated-> event: #{event.id}, subscription: #{subsciption.id} #{subsciption.status}"
    when 'invoice.created'
      invoice = Invoice.create(
        user: get_user(data_object.customer),
        status: data_object.status,
        stripe_invoice_id: data_object.id,
        dated_at: unix_to_datetime(data_object.created),
        currency: data_object.currency,
        total: cents_to_dollars(data_object.total))

      puts "Invoice created: #{event.id}, invoice: #{invoice.id}"
    when 'invoice.paid', 'invoice.payment_failed', 'invoice.payment_succeeded', 'invoice.marked_uncollectible', 'payment_action_required'
      invoice = Invoice.find_by(stripe_invoice_id: data_object.id)
      invoice.update(status: data_object.status)

      puts "Invoice updated: #{event.id}, invoice: #{invoice.id}, #{invoice.status}"
    end

    render json: { message: 'success'}
  end

  private

  def unix_to_datetime(unix_time)
    Time.at(unix_time).utc.to_datetime
  end

  def cents_to_dollars(value)
    value/100.to_f
  end

  def get_user(customer_id)
    User.find_by(stripe_customer_id: customer_id)
  end
end
