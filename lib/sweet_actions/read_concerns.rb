module SweetActions
  module ReadConcerns
    include RestConcerns
    include AuthorizationConcerns

    private

    def action
      @resource = set_resource
      authorize
      serialize
    end
  end
end
