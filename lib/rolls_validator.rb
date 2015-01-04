class RollsValidator

  STRIKE = 10

  attr_reader :first, :second

  def initialize(first = nil, second = nil)
    @first = first
    @second = second
    valid?
  end

  def self.validate(first, second)
    self.new(first, second).valid?
  end

  def valid?
    return true if bonus_ball_values?
    check_combination && first_in_range? && second_in_range?
  end

  def first_in_range?
    check = (0..STRIKE).to_a.push(nil).include?(first)
    check ? true : fail(ArgumentError, err_messages[:first_val])
  end

  def second_in_range?
    check = legit_rolls.push(nil).include?(second)
    check ? true : fail(ArgumentError, err_messages[:second_val])
  end

  def legit_rolls
    return [] if first == STRIKE
    first ? (0..(STRIKE - first)).to_a : (0..STRIKE).to_a
  end

  def check_combination
    missing_first? && illegal_strike?
  end

  def missing_first?
    check = !first && second
    !check ? true : fail(ArgumentError, err_messages[:second_nil])
  end

  def illegal_strike?
    check = first == STRIKE && second != 'nc'
    !check ? true : fail(ArgumentError, err_messages[:second_nc])
  end

  def bonus_ball_values?
    (0..STRIKE).to_a.push(nil).include?(first) && second == 'nc'
  end

  def err_messages
    {
      first_val: 'First roll must be nil or number between 0-10',
      second_nil: 'Second roll must be nil if first is nil',
      second_nc: "Second roll must be 'nc' (not-counted) if first is a strike",
      second_val: 'Second roll must be nil or number complementing first roll'
    }
  end
end
