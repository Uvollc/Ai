class InvoiceSerializer < BaseSerializer
  attributes :id, :currency, :status, :total, :stripe_invoice_id
  attribute :created, &:dated_at
end
