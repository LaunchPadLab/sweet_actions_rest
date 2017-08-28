module SweetActions
  module ReadConcerns
    include RestConcerns

    private

    def action
      @resource = set_resource
      authorize
      serialize
    end
  end
end
