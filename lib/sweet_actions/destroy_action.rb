module SweetActions
  class DestroyAction < ApiAction
    include RestConcerns

    private

    def action
      @resource = set_resource
      destroy
      serialize
    end

    def destroy
      raise "destroy method must be implemented in #{self.class.name} class since it inherits from DestroyAction"
    end
  end
end
