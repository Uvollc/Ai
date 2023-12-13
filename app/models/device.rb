class Device < ApplicationRecord

  MESSAGE_LIMIT = 3

  def reached_message_limit?
    self.message_count == MESSAGE_LIMIT
  end

  def increment_message_count
    self.update(message_count: self.message_count+1)
  end

  def create_public_chat
    self.chat_id = OpenaiApiService.create_chat
    self.save
  end
end
