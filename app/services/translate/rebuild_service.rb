module Translate
  # Service for rebuilding translations by user request
  class RebuildService
    attr_reader :task

    def initialize(params)
      @task = params[:task]
    end

    def call; end
  end
end
