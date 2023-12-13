class CreateDevicesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.string :device_token
      t.string :chat_id
      t.integer :message_count, default: 0

      t.timestamps
    end
  end
end
