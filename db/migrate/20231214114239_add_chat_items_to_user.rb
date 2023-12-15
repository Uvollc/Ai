class AddChatItemsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :payment_status, :string, default: User::PAYMENT_STATUSES[:pending]
    add_column :users, :message_count, :integer , default: 0
    add_column :users, :stripe_customer_id, :string
  end
end
