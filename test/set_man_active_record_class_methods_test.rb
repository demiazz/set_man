require 'test_helper'

class SetManActiveRecordClassMethodsTest < ActiveSupport::TestCase
  
  def setup
    @data = [
      { :name => :string_option, :value => "some_string", :new_value => "new_some_string" },
      { :name => :symbol_option, :value => :some_symbol, :new_value => :some_symbol },
      { :name => :fixnum_option, :value => 112, :new_value => 211 },
      { :name => :bignum_option, :value => 256**40, :new_value => 256**90 },
      { :name => :float_option, :value => 112.2, :new_value => 211.1 },
      { :name => :true_option, :value => true, :new_value => false },
      { :name => :false_option, :value => false, :new_value => true },
      { :name => :nil_option, :value => nil, :new_value => false },
    ]
    Options.delete_all
    @data.each do |item|
      Options.create do |option|
        option.name = item[:name]
        option.value = item[:value]
      end
    end
  end  

  test "ActiveRecord::Base inherited classes should have extended methods before calling settings method" do
    methods = [
      :get_option,
      :set_option,
      :del_option,
      :get_options,
      :set_options,
      :del_options,
      :get,
      :set,
      :del
    ]
    methods.each do |method|
      assert Options.respond_to?(method)
      assert !NotOptions.respond_to?(method)
    end
  end

  test "ActiveRecord::Base#missing_method in inherited classes should correct detect and call methods" do
    @data.each do |item|
      assert_nothing_raised (NoMethodError) { Options.send(item[:name]) }
      assert_nothing_raised (NoMethodError) { Options.send("#{item[:name]}?") }
      assert_nothing_raised (NoMethodError) { Options.send("#{item[:name]}=") }
      assert_nothing_raised (NoMethodError) { Options.send("#{item[:name]}!") }

      assert_raise (NoMethodError) { NotOptions.send(item[:name]) }
      assert_raise (NoMethodError) { NotOptions.send("#{item[:name]}?") }
      assert_raise (NoMethodError) { NotOptions.send("#{item[:name]}=") }
      assert_raise (NoMethodError) { NotOptions.send("#{item[:name]}!") }
    end
    
    assert_nothing_raised (NoMethodError) { Options.send(:not_exists_option) }
    assert_nothing_raised (NoMethodError) { Options.send(:not_exists_option?) }
    assert_nothing_raised (NoMethodError) { Options.send(:not_exists_option!) }
    assert_nothing_raised (NoMethodError) { Options.send(:not_exists_option=) }
  end

end
