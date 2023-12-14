class ChatSerializer < BaseSerializer
  attributes :id, :chat_id, :message_count

  attribute :welcome_message, if: Proc.new { |_record, params|
    params && params[:welcome_message].present?
  } do |_record, params|
    params[:welcome_message]
  end
end
