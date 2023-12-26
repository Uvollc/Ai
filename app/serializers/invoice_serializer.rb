class InvoiceSerializer < BaseSerializer
  attributes :id, :currency, :status

  attribute :total do |object|
    object.total/100.to_f
  end

  attribute :created_at do |object|
    Time.at(object.created).utc.to_datetime
  end
end
