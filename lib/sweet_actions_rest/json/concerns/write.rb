module SweetActionsRest
  module JSON
    module Concerns
      module Write
        private

        def validate_and_save
          valid? && save
        end

        def valid?
          # optional hook for subclasses
          true
        end

        def save
          resource.save
        end

        def after_save
          # hook
        end

        def after_fail
          # hook
        end
      end
    end
  end
end
