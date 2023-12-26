class SubscriptionsController < ApplicationController
  respond_to :json
  include RackSessionsFix

  before_action :authenticate_user!

  def index
    @invoices = StripeApiService.list_invoices(current_user.stripe_customer_id)

    render json: {
      status: { code: 200 },
      data: InvoiceSerializer.new(@invoices).serializable_hash[:data]
    }, status: :ok
  end

  def create
    customer =  StripeApiService.find_or_create_customer(current_user, checkout_params[:token])
    if customer
      current_user.update(stripe_customer_id: customer.id)
      charge = StripeApiService.execute_subscription(customer)

      @subscription = Subscription.create(user: current_user, status: charge.status, charge_id: charge.id )
    end

    render json: {
      status: { code: 200, message: 'Subsctiption done successfully' },
      data: SubscriptionSerializer.new(@subscription).serializable_hash[:data]
    }, status: :ok

  rescue Stripe::StripeError => e
    return render json: {
      status: { code: 400, message: "Invalid Stripe Operation: #{e.message}" },
    }, status: :forbidden unless current_user.valid_subscription?
  end

  def payment_methods
    StripeApiService.add_payment_method(current_user.stripe_customer_id, payment_method_params[:type], payment_method_params[:object].transform_keys(&:to_sym))
  end

  def list_payment_methods
    StripeApiService.list_payment_methods(current_user.stripe_customer_id)
  end

  private

  def checkout_params
    params.require(:subscription).permit(:token)
  end

  def payment_method_params
    params.require(:payment_method).permit(:type, :object)
  end
end
