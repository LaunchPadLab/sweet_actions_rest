module SweetActions
  class CreateAction < ApiAction
    include RestConcerns
    include SaveConcerns
  end
end
