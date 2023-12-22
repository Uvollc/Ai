class ChatSerializer < BaseSerializer
  attributes :id, :message_count, :welcome_message

  attribute :chat_id, &:thread_id

  attribute :run_id, if: Proc.new { |_record, params|
    params && params[:run_id].present?
  } do |_record, params|
    params[:run_id]
  end
end
