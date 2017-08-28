module SweetActions
  class CollectAction < ApiAction
    include ReadConcerns

    private

    def root_key
      plural_key
    end
  end
end
