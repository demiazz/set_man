module SetMan::SqlConverter
  
  def self.to_sql(value)
    result = Array.new
    case value.class.name
    when "String" then result[1] = :string
    when "Symbol" then result[1] = :symbol
    when "Fixnum" then result[1] = :integer
    when "Bignum" then result[1] = :integer
    when "Float" then result[1] = :rational
    when "TrueClass" then result[1] = :true
    when "FalseClass" then result[1] = :false
    when "NilClass" then result[1] = :nil
    else result[1] = :unknown
    end
    if value.class == String
      result[0] = value
    else
      result[0] = value.to_s
    end
    result
  end

  def self.from_sql(value, klass)
    case klass
    when :string then value
    when :symbol then value.to_sym
    when :integer then value.to_i
    when :rational then value.to_r
    when :true then true
    when :false then false
    when :nil then nil
    else value
    end
  end 

end
