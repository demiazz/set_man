module SetMan
  module Generators
    module OrmHelpers
      def model_contents
<<-CONTENT
  # SetMan initialization for this model.
  settings
CONTENT
      end

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
