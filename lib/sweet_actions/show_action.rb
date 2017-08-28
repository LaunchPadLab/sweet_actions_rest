module SweetActions
  class ShowAction < ApiAction
    include ReadConcerns

    def root_key
      singular_key
    end
  end
end