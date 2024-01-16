class ChangePaymentMethodDefaultStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :payment_methods, :status, from: :nil, to: 'available'
  end
end
