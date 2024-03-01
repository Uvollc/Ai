class Prompt < ApplicationRecord
  validates :display_text, :question_text, :order, presence: true
end
