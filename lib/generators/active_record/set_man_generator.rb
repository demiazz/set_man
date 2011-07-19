require 'rails/generators/active_record'
require 'generators/set_man/orm_helpers'

module ActiveRecord
  module Generators
    class SetManGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      include SetMan::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

      def copy_set_man_migration
        migration_template "migration.rb", "db/migrate/set_man_create_#{table_name}"
      end

      def inject_devise_content
        inject_into_class(model_path, class_name, model_contents) if model_exists?
      end

    end
  end
end
