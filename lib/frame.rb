require_relative 'rolls_validator'

class Frame

  STRIKE = RollsValidator::STRIKE

  attr_reader :first, :second

  def initialize(first = nil, second = nil)
    @first  = first
    @second = second
    valid?(first, second)
  end

  def self.bonus_roll
    self.new(nil, 'nc')
  end

  def roll(num_of_pins)
    return false unless incomplete?
    mark_roll(num_of_pins) if valid?(*roll_args(num_of_pins))
  end

  def mark_roll(num_of_pins)
    num_of_pins == STRIKE && empty? ? mark_strike : mark(num_of_pins)
  end

  def mark_strike
    @first, @second = STRIKE, 'nc'
  end

  def mark(num_of_pins)
    first ? @second = num_of_pins : @first = num_of_pins
  end

  def roll_args(num_of_pins)
    roll_args = first ? [first, num_of_pins] : [num_of_pins, second]
    roll_args.tap { roll_args[1] = 'nc' if roll_args[0] == STRIKE }
  end

  def valid?(*roll_args)
    RollsValidator.validate(*roll_args)
  end

  def values
    [first, second].select { |roll| (0..10).include?(roll) }
  end

  def score
    values.inject(:+) || 0
  end

  def strike?
    first == STRIKE && second == 'nc'
  end

  def spare?
    score == STRIKE && first < STRIKE
  end

  def incomplete?
    !second || (!first && second == 'nc')
  end

  def empty?
    !first
  end

  def available_rolls
    return [] if first == STRIKE
    first ? (0..(STRIKE - first)).to_a : (0..STRIKE).to_a
  end
end
