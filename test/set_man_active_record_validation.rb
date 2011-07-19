require './test_helper'

class SetManActiveRecordValidationTest < ActiveSupport::TestCase

  def setup
    Options.delete_all
  end

  test "should raise exception if name empty" do
    option = Options.new
    option.value = 111
    option.klass = :integer
    assert_raise (ActiveRecord::RecordInvalid) { option.save! }
    assert !option.save
  end

  test "should raise exception if name format is wrong" do
    option = Options.new
    option.name = "some+name"
    option.value = 111
    option.klass = :integer
    assert_raise (ActiveRecord::RecordInvalid) { option.save! }
    assert !option.save
  end

  test "shouldn't raise exception if klass is empty" do
    option = Options.new do |option|
      option.name = "some_name"
      option.value = 111
    end
    assert_nothing_raised (ActiveRecord::RecordInvalid) { option.save! }
    assert option.save
  end
  
end
