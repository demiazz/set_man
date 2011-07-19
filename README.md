#SetMan

Simple settings manager for your application.

##Requirements

Rails 3 only.

##Install

add to your gemfile
  
  gem 'set_man'

after this execute in console:

  rails g set_man [ModelName]

##Overview

For enable SetMan for model, you can add call 'settings'.

  class Options < ActiveRecord::Base

    settings

  end

You can set default options:

  class Options < ActiveRecord::Base

    self.create do |option|
      option.name = :per_page
      option.value = 20
      option.type = :integer
    end

    settings do 
      default :site_name, "Site Name"
      default :per_page, 30
    end

  end

  Options.where(:name => :site_name).first.value #=> "Site Name"
  Options.where(:name => :per_page).first.value #=> 20

For getting option, you can use `get_option`:

  Options.get_option :site_name #=> "Site Name"
  
or shorten variant:

  Options.get :site_name #=> "Site Name"

For setting option, you can use `set_option`:

  Options.set_option :site_name, "New name" #=> "New Name"

or shorten variant:

  Options.set :site_name, "New Name" #=> "New Name"

Methods `set_option` and `set` can given :to parameter:

  Options.set_option :site_name, :to => "New Name" #=> "New Name"
  Options.set :site_name, :to => "New Name" #=> "New Name"

If given second argument, and :to, `set_option` will use second argument as new value:

  Options.set_option :site_name, "New Name", :to => "Not New Name" #=> "New Name"

If option doesn't exists, then option will been created:

  Options.set_option :not_existing_option, "Some value" #=> "Some value"

For deleting option, you can use `del_option`:
  
  Options.del_option :site_name #=> "New Name"

or shorten variant:

  Options.del :site_name #=> "New Name"

You can use methods with names of options for accessing:

  Options.site_name #=> "Site Name"
  Options.site_name = "New Name" #=> "Site Name"
  Options.site_name? #=> true
  Options.site_name! #=> "Site Name"

Postfix `?` using for test of existing option.
Postfix `!` using for deleting option.

This is method not override default methods of `ActiveRecord::Base` methods and other. Example:

  Options.columns_hash #=> columns list of table

If you need returning `ActiveRecord::Base` object, instead value of option, you can use `:as_object => true`:

  Options.get_option :site_name, :as_object => true #=> #<Options ...>

This work for short names too:
  
  Options.site_name :as_object => true #=> #<Options ...>

### Multiple options

You can work with multiple options:

  Options.get_options [:site_name, :site_description] #=> { "site_name" => "Site Name", "site_description" => "Site description" }
  Options.set_options { :site_name => "New Site Name", :per_page => 20 } #=> { "site_name" => "New Site Name", :per_page => 20 }
  Options.del_options [:site_name, :per_page] #=> { "site_name" => "New Site Name", "per_page" => 20 }

If given `:as_object => true`, returning array of objects, instead hash of values.

`get_options` and `del_options` return only existing options.

## Ideas for next

* Support of cache;
* Default options;
* Options group;
* Callbacks, validations and own types.

Copyright (c) 2011 Alexey Plutalov, released under the MIT license
