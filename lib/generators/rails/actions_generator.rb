module Rails
  module Generators
    class ActionsGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_actions_folder
        template 'index.rb.erb', File.join('app/actions', plural_name, 'index.rb')
        template 'create.rb.erb', File.join('app/actions', plural_name, 'create.rb')
        template 'destroy.rb.erb', File.join('app/actions', plural_name, 'destroy.rb')
        template 'show.rb.erb', File.join('app/actions', plural_name, 'show.rb')
        template 'update.rb.erb', File.join('app/actions', plural_name, 'update.rb')
      end

      private

      def module_name
        plural_name.classify.pluralize
      end
    end
  end
end
