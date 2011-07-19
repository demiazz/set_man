require 'test_helper'

class SetManActiveRecordClassMethodsOptionsTest < ActiveSupport::TestCase

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
    @existing_names = [
      :string_option,
      :symbol_option,
      :fixnum_option,
      :bignum_option,
      :float_option,
      :true_option,
      :false_option,
      :nil_option
    ]
    @not_existing_names = @existing_names.map { |name| "not_existing_#{name}".to_sym }
  end

  test "Model#get_options should return hash of options" do
    should_returning_result = Hash.new
    Options.all.each do |option|
      should_returning_result[option.name] = option.value
    end
    assert_equal should_returning_result, Options.get_options(*@existing_names)
  end

  test "Model#get_options should return array of records if :as_object => true" do
    assert_equal Options.where(:name => @existing_names), Options.get_options(*@existing_names, :as_object => true)
  end

  test "Model#get_options should return only existing options" do
    should_returning_result = Hash.new
    Options.all.each do |option|
      should_returning_result[option.name] = option.value
    end
    assert_equal should_returning_result, Options.get_options(*(@existing_names + @not_existing_names))
    assert_equal Hash.new, Options.get_options(*@not_existing_names)
  end

  test "Model#get_options should return only existing records, if :as_object => true" do
    options = Options.where(:name => @existing_options)
    get_options = Options.get_options(*(@existing_names + @not_existing_names), :as_object => true)
    options.each_index do |index|
      assert_equal options[index], get_options[index]
    end
    assert_equal Array.new, Options.get_options(*@not_existing_names, :as_object => true)
  end

  test "Model#set_options should update existing options" do
    updates = Hash.new
    @data.each do |option|
      updates[option[:name].to_s] = option[:new_value]
    end
    assert_equal updates, Options.set_options(updates)
  end

  test "Model#set_options should update existing options, and return records, if :as_object => true" do
    updates = Hash.new
    @data.each do |option|
      updates[option[:name].to_s] = option[:new_value]
    end
    updates[:as_object] = true
    options = Options.set_options updates
    updates.delete(:as_object)
    options.each do |option|
      assert_equal Options, option.class
      assert updates.has_key? option.name
      assert_equal updates[option.name], option.value
    end
  end

  test "Model#set_options should create not existing options" do
    updates = Hash.new
    @not_existing_names.each_index do |index|
      updates[@not_existing_names[index].to_s] = @data[index][:value]
    end
    assert_equal updates, Options.set_options(updates)
    @not_existing_names.each do |name|
      assert_not_nil Options.where(:name => name).first
    end
  end

  test "Model#del_options should delete existing options, and return values" do
    right_result = Hash.new
    @data.each do |item|
      right_result[item[:name].to_s] = item[:value]
    end
    assert_equal right_result, Options.del_options(*@existing_names)
    @existing_names.each do |name|
      assert_nil Options.where(:name => name).first
    end
    assert Options.del_options(*@not_existing_names).empty?
  end

  test "Model#del_options should delete existing options, and return records, if :as_object => true" do
    del_options = Options.del_options(*@existing_names, :as_object => true)
    del_options.each do |option|
      assert @existing_names.include?(option.name.to_sym)
      assert_equal Options, option.class
      assert_nil Options.where(:name => option.name).first
    end
  end

end
