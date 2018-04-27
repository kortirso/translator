module FileHandle
  module Upload
    module Concerns
      # Common methods for string-based uploading
      module Stringable
        private def post_initialize(_args)
          prepare_file
          @uploaded_file = task.file_content
        end
      end
    end
  end
end
