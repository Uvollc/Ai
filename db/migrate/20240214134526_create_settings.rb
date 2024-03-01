class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      # t.boolean :public_access, default: true
      # t.text :chats_welcome_message, default: WELCOME_MESSAGE
      # t.text :chats_agreement_message, default: AGREEMENT_MESSAGE
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
