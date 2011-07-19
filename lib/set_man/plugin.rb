module SetMan::Plugin

  def self.setup!
    ActiveRecord::Base.send :include, SetMan::ActiveRecord::Setup if defined?(ActiveRecord::Base)
  end

end
