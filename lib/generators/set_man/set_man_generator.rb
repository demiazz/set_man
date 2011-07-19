module SetMan
  module Generators
    class SetManGenerator < Rails::Generators::NamedBase
      namespace "set_man"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with SetMan " <<
           "configuration plus a migration file."

      hook_for :orm

    end
  end
end
