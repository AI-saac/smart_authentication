include Rails::Generators::Migration

module SmartAuthentication
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        insert_into_file "app/controllers/application_controller.rb", "
          \tinclude SessionsHelper\n\n
          \t# Confirms a logged-in user.\n
          \tdef logged_in_user\n
          \t\tunless logged_in?\n
          \t\tstore_location\n
          \t\tflash[:danger] = 'Please log in.'\n
          \t\tredirect_to login_url\n", after: "protect_from_forgery with: :exception\n"
        copy_file "app/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
        copy_file "app/models/user.rb", "app/models/user.rb"
        copy_file "app/views/users/new.html.haml", "app/views/users/new.html.haml"
        copy_file "app/helpers/sessions_helper.rb", "app/helpers/sessions_helper.rb"
        migration_template "db/migrate/create_users.rb", "db/migrate/create_users.rb"
        insert_into_file "config/routes.rb", "\tget 'signup' => 'users#new'\n\tget 'login' => 'sessions#new'\n\tpost 'login' => 'sessions#create'\n\tdelete 'logout' => 'sessions#destroy'\n", after: "Rails.application.routes.draw do\n"
        insert_into_file "Gemfile", "gem 'bcrypt'\n", after: "source 'https://rubygems.org'\n"
      end

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end
    end
  end
end
