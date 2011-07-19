require 'test_helper'

class SetManActiveRecordDefaultTest < ActiveSupport::TestCase

  test "should set default option, if not exists" do
    assert_equal "Site Name", DefaultOptions.where(:name => :site_name).first.value    
  end

  test "shouldn't set default option, if exists do" do
    assert_equal 20, DefaultOptions.where(:name => :per_page).first.value
  end

end
