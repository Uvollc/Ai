class CreateUserChats < ActiveRecord::Migration[7.1]
  def change
    create_table :user_chats do |t|
      t.references :user
      t.string :chat_id
      t.timestamps
    end
  end
end
