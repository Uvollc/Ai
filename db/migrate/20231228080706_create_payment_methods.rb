class CreatePaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_methods do |t|
      t.string :last_digits
      t.string :brand
      t.datetime :expiry
      t.string :status
      t.references :user
      t.string :stripe_method_id

      t.timestamps
    end
  end
end
