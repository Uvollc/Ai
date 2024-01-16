class PromptSerializer < BaseSerializer
  set_type :prompt
  attributes :display_text, :question_text, :order
end
