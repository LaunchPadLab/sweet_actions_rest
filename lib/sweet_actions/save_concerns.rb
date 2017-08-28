module SweetActions
  module SaveConcerns
    def action
      @resource = set_resource
      authorize
      validate_and_save ? success : failure
    end

    def root_key
      singular_key
    end

    def validate_and_save
      valid? && save
    end

    def valid?
      true
    end

    def save
      raise "save method must be implemented by #{self.class.name} since it includes SaveConcerns"
    end

    def success
      after_save
      serialize
    end

    def failure
      after_fail
      @response_code = '422'
      serialize_errors
    end

    def after_save
      # hook
    end

    def after_fail
      # hook
    end

    def map_base_to__error(error_obj)
      error_obj[:_error] = error_obj.delete(:base) if error_obj.key? :base
      error_obj
    end
  end
end
