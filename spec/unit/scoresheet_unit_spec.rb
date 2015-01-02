describe ScoreSheet do

  let (:empty_scoresheet)   { ScoreSheet.new }
  let (:gutter_scoresheet)  { create_scoresheet(0) }
  let (:average_scoresheet) { create_scoresheet(4) }
  let (:spare_scoresheet)   { create_scoresheet(5) }
  let (:perfect_scoresheet) { create_scoresheet(10) }
  let (:scoresheets) {
    [
      empty_scoresheet,
      gutter_scoresheet,
      average_scoresheet,
      spare_scoresheet,
      perfect_scoresheet
    ]
  }

  context 'Initialization' do

    it 'is done with 10 frames by default' do
      expect(empty_scoresheet.frames.count).to eq 10
    end

    it 'is done with empty frames by default' do
      empty_scoresheet.frames.each do |frame|
        expect(frame.empty?).to be true
      end
    end
  end

  context 'After Initialization' do

    context 'Current Roll' do

      it 'can find the index of the current roll' do
        expect(empty_scoresheet.current_roll).to eq ''
        5.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.current_roll).to eq '4'
      end
    end

    context 'Current Frame' do

      it 'can find the index of the current frame' do
        expect(empty_scoresheet.current_frame).to eq 0
        2.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.current_roll).to eq '1'
      end

      it 'returns nil if all frames have been played' do
        20.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.current_frame).to eq nil
      end
    end

    context 'Mark Rolls' do

      it 'can mark a roll' do
        empty_scoresheet.mark_roll(1)
        expect(empty_scoresheet.total_score).to eq 1
      end

      it 'can mark more than one roll' do
        2.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.total_score).to eq 2
      end

      it 'can mark 20 regular rolls' do
        20.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.total_score).to eq 20
      end

      it 'can not mark more than 20 regular rolls' do
        20.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.mark_roll(1)).to be false
      end
    end

    context 'All Rolls' do

      it 'knows when scoresheet is not full' do
        expect(empty_scoresheet.done?).to be false
      end

      it 'knows when scoresheet is full' do
        20.times { empty_scoresheet.mark_roll(1) }
        expect(empty_scoresheet.done?).to be true
      end
    end

    context 'Bomus Rolls' do

      it 'adds a bonus roll if tenth frame is a spare' do
        20.times { empty_scoresheet.mark_roll(5) }
        expect(empty_scoresheet.frames.count).to eq 11
      end

      it 'adds two bonus rolls if tenth frame is a strike' do
        18.times { empty_scoresheet.mark_roll(0) }
        empty_scoresheet.mark_roll(10)
        expect(empty_scoresheet.frames.count).to eq 12
      end

      it 'does not add more than two bonus rolls' do
        12.times { empty_scoresheet.mark_roll(10) }
        expect(empty_scoresheet.frames.count).to eq 12
      end
    end

    context 'Base Score' do

      it 'knows the base score before frames are played' do
        expect(empty_scoresheet.base_score).to eq 0
      end

      it 'can calculate the base score for one frame' do
        empty_scoresheet.mark_roll 1
        expect(empty_scoresheet.base_score).to eq 1
      end

      it 'can calculate the base score for more than one frame' do
        10.times { empty_scoresheet.mark_roll 2 }
        expect(empty_scoresheet.base_score).to eq 20
      end
    end

    context 'Bonus Points' do

      it 'can calculate the bonus points for a spare' do
        2.times { empty_scoresheet.mark_roll 5 }
        empty_scoresheet.mark_roll 7
        expect(empty_scoresheet.bonus_points).to eq 7
      end

      it 'can calculate the bonus points for a strike' do
        [10, 7, 2].each { |value| empty_scoresheet.mark_roll(value) }
        expect(empty_scoresheet.bonus_points).to eq 9
      end
    end

    context 'Running Score' do

      it 'can calculate the running score' do
        rolls, scores = [10, 4, 4], [10, 18, 26]
        rolls.each_with_index do |roll_value, index|
          empty_scoresheet.mark_roll(roll_value)
          expect(empty_scoresheet.total_score).to eq scores[index]
        end
      end
    end

    context 'Total Score' do

      it 'can calculate the total score before frames are played' do
        expect(empty_scoresheet.total_score).to eq 0
      end

      it 'can calculate the total score for one frame' do
        2.times { empty_scoresheet.mark_roll(4) }
        expect(empty_scoresheet.total_score).to eq 8
      end

      it 'can calculate the total score for more than one frame' do
        4.times { empty_scoresheet.mark_roll(4) }
        expect(empty_scoresheet.total_score).to eq 16
      end

      it 'can calculate the total score for all frames' do
        expected_results = [0, 0, 80, 150, 300]
        scoresheets.each_with_index do |scoresheet, index|
          expect(scoresheet.total_score).to eq expected_results[index]
        end
      end
    end
  end
end
