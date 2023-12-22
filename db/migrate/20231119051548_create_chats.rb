class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :chatable, polymorphic: true
      t.string :title
      t.string :thread_id
      t.integer :message_count, default: 0

      t.timestamps
    end
  end
end
