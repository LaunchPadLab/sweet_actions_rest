module SweetActions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a Sweet Actions initializer in your application."

      def copy_initializer
        copy_file "initializer.rb", "config/initializers/sweet_actions.rb"
      end
    end
  end
end
