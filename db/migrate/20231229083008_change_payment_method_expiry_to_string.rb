class ChangePaymentMethodExpiryToString < ActiveRecord::Migration[7.1]
  def change
    change_column :payment_methods, :expiry, :string
  end
end
