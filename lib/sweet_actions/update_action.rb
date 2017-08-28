module SweetActions
  class UpdateAction < ApiAction
    include RestConcerns
    include SaveConcerns
  end
end