module SweetActions
  module REST
    module Save
      include Base

      private

      def action
        @resource = set_resource
        authorize
        if validate_and_save
          after_save
          respond_with_success
        else
          after_fail
          respond_with_error
        end
      end

      def validate_and_save
        valid? && save
      end

      def respond_with_success
        raise "respond_with_success method must be implemented by #{self.class.name} since it includes SweetActions::REST::SaveConcerns"
      end

      def respond_with_error
        raise "respond_with_error method must be implemented by #{self.class.name} since it includes SaveConcerns"
      end

      def valid?
        # optional hook for subclasses
        true
      end

      def save
        resource.save
      end

      def save
        raise "save method must be implemented by #{self.class.name} since it includes SaveConcerns"
      end

      def after_save
        # hook
      end

      def after_fail
        # hook
      end
    end
  end
end
