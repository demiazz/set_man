require 'test_helper'

class SetManSqlConverterTest < ActiveSupport::TestCase

  def setup
    @data = [
      { :klass => :string, :from => "some_string", :to => "some_string" },
      { :klass => :symbol, :from => :some_symbol, :to => "some_symbol" },
      { :klass => :integer, :from => 112, :to => "112" },
      { :klass => :integer, :from => 256**40, :to => (256**40).to_s },
      { :klass => :rational, :from => 112.2, :to => "112.2" },
      { :klass => :true, :from => true, :to => "true" },
      { :klass => :false, :from => false, :to => "false" },
      { :klass => :nil, :from => nil, :to => "" },
      { :klass => :unknown, :from => [1, 2, 3], :to => [1, 2, 3].to_s }
    ] 
  end

  test "SetMan::SqlConverter#to_sql should correct convert values" do
    @data.each do |item|
      assert_equal [item[:to], item[:klass]], SetMan::SqlConverter.to_sql(item[:from])
    end
  end

  test "SetMan::SqlConverter#from_sql should correct convert values" do
    @data.each do |item|
      unless item[:klass] == :unknown
        assert_equal item[:from], SetMan::SqlConverter.from_sql(item[:to], item[:klass])
      else
        assert_equal item[:to], SetMan::SqlConverter.from_sql(item[:to], item[:klass])
      end
    end
  end

  test "SetMan::SqlConverter#from_sql should correct convert output of SetMan::SqlConverter#to_sql" do
    @data.each do |item|
      converted = SetMan::SqlConverter.to_sql(item[:from])
      unless item[:klass] == :unknown
        assert_equal item[:from], SetMan::SqlConverter.from_sql(converted[0], converted[1])
      else
        assert_equal item[:to], SetMan::SqlConverter.from_sql(converted[0], converted[1])
      end
    end
  end

end
