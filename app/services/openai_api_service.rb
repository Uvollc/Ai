class OpenaiApiService
  class << self
    def create_chat
      thread = AI_CLIENT.threads.create().transform_keys(&:to_sym)

      thread[:id]
    end

    def create_message(thread_id, message)
      AI_CLIENT.messages.create(
        thread_id: thread_id,
        parameters: {
          role: "user",
          content: message})
    end

    def run_chat(thread_id)
      run = AI_CLIENT.runs.create(
        thread_id: thread_id,
        parameters: {assistant_id: ENV.fetch("MEDICAL_ASSISTANT_ID")}
      ).transform_keys(&:to_sym)
      run[:id]
    end

    def wait_on_run(thread_id, run_id)
      loop do
        sleep(3)
        run = AI_CLIENT.runs.retrieve(thread_id: thread_id, id: run_id).transform_keys(&:to_sym)
        unless run[:status] == "queued" || run[:status] == "in_progress"
          return true
        end
      end
      return false
    end

    def retrieve_messages(thread_id)
      messages = AI_CLIENT.messages.list(thread_id: thread_id)
    end

    def delete_chat(thread_id)
      AI_CLIENT.threads.delete(id: thread_id)
    end
  end
end
