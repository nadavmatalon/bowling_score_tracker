require_relative 'frame'

class ScoreSheet

  attr_reader :frames

  def initialize
    @frames = (1..10).map { Frame.new }
  end

  def mark_roll(num_of_pins)
    frame_index = current_frame
    return false unless frame_index
    frames[frame_index].roll(num_of_pins)
    update_bonus_rolls if frame_index == 9
  end

  def current_frame
    frames.find_index(&:incomplete?)
  end

  def update_bonus_rolls
    last_frame = frames[9]
    add_rolls(1) if last_frame.spare?
    add_rolls(2) if last_frame.strike?
  end

  def add_rolls(num_rolls)
    num_rolls.times { @frames.push(bonus_roll) unless max_frames }
  end

  def bonus_roll
    Frame.bonus_roll
  end

  def total_score
    [base_score, bonus_points].compact.inject(:+) || 0
  end

  def base_score
    game_frames.map(&:score).inject(:+)
  end

  def bonus_points
    points = 0
    game_frames.each.with_index(1) do |frame, index|
      points += spare_bonus(index) if frame.spare?
      points += strike_bonus(index) if frame.strike?
    end
    points
  end

  def done?
    frames.map(&:incomplete?).none?
  end

  def current_roll
    rolls = (0..11).map { Array.new([nil, nil]) }
    frames.map(&:values).each_with_index do |frame, index|
      frame.each_with_index { |roll, count| rolls[index][count] = roll }
    end
    rolls.flatten.rindex { |roll| roll }.to_s || ''
  end

  def available_rolls
    current_frame ? frames[current_frame].available_rolls : false
  end

  def max_frames
    frames.count == 12
  end

  def game_frames
    frames[0..9]
  end

  def spare_bonus(index)
    frames[index].values.first || 0
  end

  def strike_bonus(index)
    frames[index..index.next].map(&:values).flatten[0..1].inject(:+) || 0
  end
end
