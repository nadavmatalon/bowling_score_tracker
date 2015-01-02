def create_scoresheet(rolls_value)
  scoresheet = ScoreSheet.new
  case rolls_value
    when 10 then num_of_rolls = 12
    when 5  then num_of_rolls = 21
    else num_of_rolls = 20
  end
  num_of_rolls.times { scoresheet.mark_roll(rolls_value) }
  scoresheet
end
