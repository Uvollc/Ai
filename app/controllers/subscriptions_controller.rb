class SubscriptionsController < ApiController
  respond_to :json
  include RackSessionsFix

  before_action :authenticate_user!

  def index
    @invoices = current_user.invoices.order(updated_at: :desc)

    render json: {
      status: { code: 200 },
      data: InvoiceSerializer.new(@invoices).serializable_hash[:data]
    }, status: :ok
  end

  def create
    customer =  StripeApiService.find_or_create_customer(current_user)
    if customer
      current_user.update(stripe_customer_id: customer.id)
      client_secret = StripeApiService.create_checkout_session(customer)
    end

    render json: {
      status: { code: 200, message: 'Session created successfully.' },
      data: client_secret
    }, status: :ok

  rescue Stripe::StripeError => e
    return render json: {
      status: { code: 400, message: "Invalid Stripe Operation: #{e.message}" },
    }, status: :forbidden
  end

  def show
    session =  StripeApiService.retrieve_session(params[:session_id])

    render json: {
      status: { code: 200 },
      data: { status: session.status }
    }, status: :ok

  rescue Stripe::StripeError => e
    return render json: {
      status: { code: 400, message: "Invalid Stripe Operation: #{e.message}" },
    }, status: :forbidden
  end

  def payment_methods
    StripeApiService.add_payment_method(current_user.stripe_customer_id, payment_method_params[:type], payment_method_params[:object].transform_keys(&:to_sym))
  end

  def list_payment_methods
    @payment_methods = current_user.payment_methods.order(updated_at: :desc)

    render json: {
      status: { code: 200 },
      data: PaymentMethodSerializer.new(@payment_methods).serializable_hash[:data]
    }, status: :ok
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:type, :object)
  end
end
