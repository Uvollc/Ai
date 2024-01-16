class CreateSubscription < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.string :status, default: "pending"
      t.string :charge_id

      t.timestamps
    end
  end
end
