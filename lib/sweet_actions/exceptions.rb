module SweetActions
  module Exceptions
    class NotAuthorized < StandardError; end

    class ActionNotFound < StandardError
      attr_reader :path, :class_name

      def initialize(args = {})
        @path = args.fetch(:path, '')
        @class_name = args.fetch(:class_name, '')
      end

      def message
        "Action class not found. Please make sure #{class_name} exists at app/actions/#{path}."
      end
    end
  end
end