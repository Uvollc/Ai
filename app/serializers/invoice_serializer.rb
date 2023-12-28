class InvoiceSerializer < BaseSerializer
  attributes :id, :currency, :status, :total
  attribute :created, &:dated_at
end
