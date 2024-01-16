class Chat < ApplicationRecord
  belongs_to :chatable, polymorphic: true

  before_create -> (chat) { chat.thread_id = OpenaiApiService.create_chat }
  after_destroy -> (chat) { OpenaiApiService.delete_chat(chat.thread_id) }

  MESSAGE_LIMIT = 4

  def welcome_message
    return "Please agree & acknowledge that you are aware I'm not a substitute for professional medical evaluation, so it's important to consult a healthcare provider for accurate diagnosis and treatment even if I answer your medical question.  Do you agree to our terms of service?" if public_assistant

    "Hello, what is your health related question? Tell me your symptoms or ask me general health questions like a lab result or what does diastolic pressure mean."
  end

  def reached_message_limit?
    self.message_count >= MESSAGE_LIMIT
  end

  def make_messaging_updates(message)
    OpenaiApiService.create_message(self.thread_id, message)
    run_id = OpenaiApiService.run_chat(self.thread_id, self.public_assistant)
    self.title = message[0..50] if message_count == 0
    self.title = message[0..50] if (message_count == 1 && public_assistant)
    self.message_count += 1
    self.save

    run_id
  end
end
