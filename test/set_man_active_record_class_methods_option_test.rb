require 'test_helper'

class SetManActiveRecordClassMethodsOptionTest < ActiveSupport::TestCase

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

  test "Model#get_option should return right value" do
    @data.each do |item|
      assert_equal item[:value], Options.get_option(item[:name])
    end
  end

  test "Model#get_option should return right record if :as_object => true" do
    @data.each do |item|
      assert_equal Options.where(:name => item[:name]).first, Options.get_option(item[:name], :as_object => true)
      assert_equal item[:name].to_s, Options.get_option(item[:name], :as_object => true).name
      assert_equal item[:value], Options.get_option(item[:name], :as_object => true).value
    end
  end

  test "Model#get_option should return nil, if option doesn't exists" do
    assert_nil Options.get_option(:not_exists_option)
    assert_nil Options.get_option(:not_exists_option, :as_object => true)
  end

  test "Model#set_option should return right new value" do
    @data.each do |item|
      assert_equal item[:new_value], Options.set_option(item[:name], item[:new_value])
    end
  end

  test "Model#set_option should return right record if :as_object => true" do
    @data.each do |item|
      assert_equal Options.set_option(item[:name], item[:new_value], :as_object => true), Options.where(:name => item[:name]).first
      assert_equal item[:new_value], Options.where(:name => item[:name]).first.value
    end
  end

  test "Model#set_option should return create new option, if option doesn't exists" do
    Options.delete_all
    @data.each do |item|
      assert_equal item[:value], Options.set_option(item[:name], item[:value])
    end
  end

  test "Model#set_option should right use :to option" do
    @data.each do |item|
      assert_equal item[:new_value], Options.set_option(item[:name], :to => item[:new_value])
    end
  end

  test "Model#set_option should use arg instead :to option, if given both" do
    @data.each do |item|
      assert_equal item[:new_value], Options.set_option(item[:name], item[:new_value], :to => item[:value])
    end
  end

  test "Model#del_option should delete option and return value" do
    @data.each do |item|
      assert_equal item[:value], Options.del_option(item[:name])
      assert_nil Options.where(:name => item[:name]).first
    end
  end

  test "Model#del_option should delete option, and return record if :as_object => true" do
    @data.each do |item|
      assert_equal Options.where(:name => item[:name]).first, Options.del_option(item[:name], :as_object => true)
      assert_nil Options.where(:name => item[:name]).first
    end
  end

  test "Model#del_option should return nil if option doesn't exists" do
    assert_nil Options.del_option(:not_exists_option)
    assert_nil Options.del_option(:not_exists_option, :as_object => true)
  end
        
end
