class AddPublicAssistantFlagToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :public_assistant, :boolean, default: false
  end
end
