class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts do |t|
      t.string :display_text
      t.string :question_text
      t.integer :order
    end
  end
end
