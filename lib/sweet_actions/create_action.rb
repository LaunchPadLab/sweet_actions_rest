module SweetActions
  class CreateAction < ApiAction
    include RestConcerns
    include SaveConcerns

    def save
      resource.save
    end
  end
end
