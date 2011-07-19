module SetMan::ActiveRecord

  module Setup

    def self.included(klass)
      klass.module_eval do
        extend ClassMethods
      end
    end

    module ClassMethods

      def settings(&block)
        self.send :include, SetMan::ActiveRecord::Extension
        self.class_eval &block if block
      end

    end

  end

end
