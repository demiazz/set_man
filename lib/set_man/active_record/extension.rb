module SetMan::ActiveRecord

  module Extension

    module ClassMethods

      # TODO: May be add support of block for *_option and *_options interfaces?

      def check_option_name(name)
        unless name.class == String or name.class == Symbol
          return nil
        end
        unless /^[a-z][a-z0-9_]*$/ === name.to_s
          return nil
        end
        true
      end

      # *_option interface
      
      # USAGE
      # Model.get_option :some_option #=> return value of some_option
      # Model.get_option :some_option, :as_object => true #=> return some_option as Model instance
      def get_option(*args)
        # Extract function options
        as_object = args.extract_options![:as_object]
        name = args[0]
        # Extract option
        if self.check_option_name(name)
          option = self.where(:name => name).first
          as_object ? option : option.value if option
        end
      end

      # USAGE
      # Model.set_option :some_option, value
      # Model.set_option :some_option, :to => value
      # Model.set_option :some_option, value, :as_object => true
      # Model.set_option :some_option, :to => value, :as_object => true
      def set_option(*args)
        # Extract function options
        function_options = args.extract_options!
        as_object = function_options[:as_object]
        name = args[0]
        value = args.size == 2 ? args[1] : function_options[:to]
        # Set new value for option
        if self.check_option_name(name)
          option = self.find_or_create_by_name(name)
          option.value = value
          as_object ? option : option.value if option.save
        end
      end

      # USAGE
      # Model.del_option :some_option #=> value of some_option
      # Model.del_option :some_option, :as_object => true
      def del_option(*args)
        # Extract function options
        as_object = args.extract_options![:as_object]
        name = args[0]
        # Delete option
        if self.check_option_name(name)
          option = self.where(:name => name).first
          as_object ? option.destroy : option.destroy.value if option
        end
      end

      # *_options interface

      def get_options(*args)
        # Extract function options
        as_object = args.extract_options![:as_object]
        names = args.delete_if { |name| !self.check_option_name(name) }
        # Extract options values
        unless names.empty?
          options = self.where(:name => names)
          if as_object
            options
          else
            result = Hash.new
            options.each { |option| result[option.name] = option.value }
            result
          end
        end
      end

      def set_options(*args)
        # TODO: This function is very hard. Optimize it!
        # TODO: If possible, function logic must be rewritting for use multiple updates.
        
        # Extract function options
        function_options = args.extract_options!
        as_object = function_options.delete(:as_object)
        updates = function_options.delete_if { |name, value| !self.check_option_name(name) }
        # Update attributes
        if as_object
          result = Array.new
          updates.each { |name, value| result << self.set_option(name, value, :as_object => true) }
          result.delete_if { |item| !item }
        else
          result = Hash.new
          updates.each do |name, value|
            option = self.set_option name, value, :as_object => true
            result[option.name] = option.value if option
          end
        end
      end

      def del_options(*args)
        # Extract function options
        as_object = args.extract_options![:as_object]
        names = args.delete_if { |arg| !self.check_option_name(arg) }
        # Delete options
        # destroy_all not used, because this don't return list of deleted records, but return count of deleted records
        if as_object
          result = names.map { |name| self.where(:name => name).first.delete }
          result.delete_if { |item| !item }
        else
          result = Hash.new
          names.each do |name|
            option = self.where(:name => name).first
            result[option.name] = option.delete.value if option
          end
          result
        end
      end

      alias get get_option
      alias set set_option
      alias del del_option

      def method_missing(method_id, *args, &block)
        begin
          super
        rescue
          case method_id
          when /^[a-z][a-z0-9_]*$/ 
            self.get_option method_id, *args
          when /^[a-z][a-z0-9_]*=$/
            self.set_option method_id.to_s.chop, *args
          when /^[a-z][a-z0-9_]*!$/
            self.del_option method_id.to_s.chop, *args
          when /^[a-z][a-z0-9_]*\?$/
            self.where(:name => method_id.to_s.chop).exists?
          else raise NoMethodError, "undefined method `#{method_id} for #{self.name}"
          end
        end
      end

      def default(name, value)
        unless self.exists?(name)
          self.create do |option|
            option.name = name
            option.value = value
          end
        end
      end

    end

    module InstanceMethods

      protected 
        
        def to_sql
          sql = SetMan::SqlConverter.to_sql(self[:value])
          self[:value] = sql[0]
          self[:klass] = sql[1]
        end

        def from_sql
          self[:klass] = self[:klass].to_sym
          self[:value] = SetMan::SqlConverter.from_sql(self[:value], self[:klass])
        end
        
    end

    def self.included(klass)
      klass.module_eval do
        include InstanceMethods
        extend ClassMethods

        # Callbacks 
        before_validation :to_sql
        after_save :from_sql
        after_find :from_sql
      end
      klass.class_eval do
        # Validations
        validates_format_of :name, :with => /^[a-z][a-z0-9_]*$/, :message => "Invalid format of name!"
        validates_presence_of :name, :klass
      end
    end 

  end

end
