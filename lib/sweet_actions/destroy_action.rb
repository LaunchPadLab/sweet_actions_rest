module SweetActions
  class DestroyAction < ApiAction
    include RestConcerns
    include AuthorizationConcerns

    private

    def action
      @resource = set_resource
      authorize
      destroy
      serialize
    end

    def destroy
      raise "destroy method must be implemented in #{self.class.name} class since it inherits from DestroyAction"
    end
  end
end
