module SweetActions
  module RestConcerns
    include RestSerializerConcerns

    attr_reader :resource_name, :resource

    private

    def resource_name
      path_parameters[:resource_name]
    end

    def set_resource
      raise "set_resource method must be implemented in #{self.class.name} class since it includes RestConcerns"
    end

    def resource
      return @resource if defined?("@resource")
      raise "@resource must be set for #{self.class.name} since it includes RestConcerns"
    end

    def authorize?
      true
    end

    def authorize
      return unless authorize?
      return true if authorized?
      unauthorized
    end

    def authorized?
      raise "authorized? method must be implemented in #{self.class.name} class"
    end

    def unauthorized
      raise Exceptions::NotAuthorized
    end

    def resource_class
      resource_name.constantize
    end

    def resource_decanter
      @resource_decanter ||= "#{resource_class.to_s.classify}Decanter".constantize
    end

    def resource_params
      @resource_params ||= resource_decanter.decant(params[singular_key])
    end

    def plural_key
      resource_class.name.underscore.pluralize
    end

    def singular_key
      resource_class.name.underscore
    end
  end
end
