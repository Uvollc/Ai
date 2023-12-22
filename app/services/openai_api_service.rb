class OpenaiApiService
  class << self
    def greet_thread(count)
      "Greet a new thread if there are no messages in the thread"
      return "Hello, what is your health related question? Tell me your symptoms or ask me general health questions like a lab result or what does diastolic pressure mean." if count == 0
    end

    def create_chat
      thread = AI_CLIENT.threads.create().transform_keys(&:to_sym)

      thread[:id]
    end

    def create_message(chat_id, message)
      AI_CLIENT.messages.create(
        thread_id: chat_id,
        parameters: {
          role: "user",
          content: message})
    end

    def run_chat(chat_id)
      run = AI_CLIENT.runs.create(
        thread_id: chat_id,
        parameters: {assistant_id: ENV.fetch("MEDICAL_ASSISTANT_ID")}
      ).transform_keys(&:to_sym)
      run[:id]
    end

    def wait_on_run(chat_id, run_id)
      loop do
        sleep(3)
        run = AI_CLIENT.runs.retrieve(thread_id: chat_id, id: run_id).transform_keys(&:to_sym)
        unless run[:status] == "queued" || run[:status] == "in_progress"
          return true
        end
      end
      return false
    end

    def retrieve_messages(chat_id)
      messages = AI_CLIENT.messages.list(thread_id: chat_id)
    end
  end
end
