module SweetActions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Creates a Sweet Actions initializer in your application.'

      def copy_initializer
        copy_file 'initializer.rb', 'config/initializers/sweet_actions.rb'
        copy_file 'collect_action.rb', 'app/actions/collect_action.rb'
        copy_file 'create_action.rb', 'app/actions/create_action.rb'
        copy_file 'destroy_action.rb', 'app/actions/destroy_action.rb'
        copy_file 'show_action.rb', 'app/actions/show_action.rb'
        copy_file 'update_action.rb', 'app/actions/update_action.rb'
      end
    end
  end
end
