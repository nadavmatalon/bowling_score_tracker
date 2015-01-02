require_relative 'scoresheet'

class Player

  attr_reader :name, :scoresheet

  def initialize(name = 'dude')
    @name = name
    @scoresheet = ScoreSheet.new
  end

  def roll(num_of_pins)
    scoresheet.mark_roll(num_of_pins)
  end

  def score
    scoresheet.total_score
  end

  def current_roll
    scoresheet.current_roll
  end

  def current_frame
    scoresheet.current_frame
  end

  def available_rolls
    scoresheet.available_rolls
  end

  def done?
    scoresheet.done?
  end

  def in_bonus?
    (10..11).include?(current_frame) && !done?
  end
end
