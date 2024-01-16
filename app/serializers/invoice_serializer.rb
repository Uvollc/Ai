class InvoiceSerializer < BaseSerializer
  attributes :id, :currency, :status, :total, :stripe_invoice_id
  attribute :created do |obj|
    obj.dated_at.strftime('%b. %d, %Y')
  end
end
