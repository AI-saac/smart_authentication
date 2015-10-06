module SmartAuthentication
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        copy_file "app/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
        copy_file "app/models/user.rb", "app/models/user.rb"
        copy_file "app/helpers/sessions_helper.rb", "app/helpers/sessions_helper.rb"
        migration_template "db/migrate/create_users.rb", "db/migrate/create_users.rb"
        insert_into_file "config/routes.rb", "get 'signup' => 'users#new'\nget 'login' => 'sessions#new'\npost 'login' => 'sessions#create'\ndelete 'logout' => 'sessions#destroy'", after: "routes.draw do'\n"
      end
    end
  end
end
