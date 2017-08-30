module SweetActions
  class UpdateAction < ApiAction
    include RestConcerns
    include SaveConcerns

    def save
      resource.attributes = resource_params
      resource.save
    end
  end
end