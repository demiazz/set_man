require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'set_man.rb')

##### ACTIVERECORD TEST INIT #####

# Connect to memory SQLite database
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:", :database => 'setman_test')

# Create scheme of database
ActiveRecord::Schema.define(:version => 1) do

  create_table :options, :force => true do |t|
    t.string :name
    t.text :value
    t.string :klass
	end

  create_table :not_options, :force => true do |t|
    t.string :name
    t.text :value
    t.string :klass
  end

  create_table :default_options, :force => true do |t|
    t.string :name
    t.text :value
    t.string :klass
  end

end

# Model with SetMan extension
class Options < ActiveRecord::Base

  settings

end

# Model without SetMan extension
class NotOptions < ActiveRecord::Base

end

# Model for testing default options
class DefaultOptions < ActiveRecord::Base

  self.create do |option|
    option.name = :per_page
    option.value = 20
    option.klass = :integer
  end

  settings do 
    default :site_name, "Site Name"
    default :per_page, 30
  end

end
