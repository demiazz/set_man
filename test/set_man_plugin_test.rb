require 'test_helper'

class SetManPluginTest < ActiveSupport::TestCase

  test "ActiveRecord::Base should have 'settings' method" do
    assert ActiveRecord::Base.respond_to?(:settings)
  end

  test "ActiveRecord::Base inherited classes should have 'settings' method" do
    assert Options.respond_to?(:settings)
    assert NotOptions.respond_to?(:settings)
  end

end
