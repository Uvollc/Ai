class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :status
      t.string :currency
      t.datetime :dated_at
      t.float :total
      t.references :user
      t.string :stripe_invoice_id

      t.timestamps
    end
  end
end
