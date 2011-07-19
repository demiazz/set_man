$:.push File.dirname(__FILE__)

require 'active_support/core_ext/module/attribute_accessors'

module SetMan 

end

require 'set_man/plugin'
require 'set_man/active_record/extension'
require 'set_man/active_record/setup'
require 'set_man/sql_converter'

SetMan::Plugin.setup!
