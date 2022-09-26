module Validations
  def validate_non_empty(string, error)
    raise(error) if string.empty?
  end

  def validate_positive(value, error)
    raise(error) unless value.to_i.positive?
  end

  def validate_capital_letter(string, error)
    raise(error) if string[0].upcase != string[0]
  end

  def validate_length_less(string, error, length)
    raise(error) if string.length < length
  end

  def validate_length_more(string, error, length)
    raise(error) if string.length > length
  end

  def validate_length_exactly(string, error, length)
    raise(error) unless string.length == length
  end

  def validate_is_integer(integer, error)
    raise(error) unless integer.is_a?(Integer)
  end

  def validate_integer_less(integer, error, value)
    raise(error) if integer < value
  end

  def validate_integer_more(integer, error, value)
    raise(error) if integer > value
  end
end
