describe Frame do

  let (:empty_frame)      { Frame.new }
  let (:incomplete_frame) { Frame.new(1) }
  let (:regular_frame)    { Frame.new(1, 5) }
  let (:spare_frame)      { Frame.new(5, 5) }
  let (:strike_frame)     { Frame.new(10, 'nc') }
  let (:frames) {
    [
      empty_frame,
      incomplete_frame,
      regular_frame,
      spare_frame,
      strike_frame
    ]
  }
  let (:invalid_args)  {
    [
      -1, 11, '1', :a,
      [1], { 'a' => 1 }
    ]
  }
  let (:unmatched_rolls) {
    [
      [2, 9], [3, 8],
      [4, 7], [5, 6],
      [6, 5], [7, 4],
      [8, 3], [9, 2]
    ]
  }

  context 'In General' do
    it 'knows that the value of a STRIKE is 10' do
      expect(Frame::STRIKE).to eq 10
    end
  end

  context 'Initialization' do

    it 'can be done without roll values' do
      expect{ Frame.new }.not_to raise_error
    end

    it 'can be done with only first roll value' do
      expect{ Frame.new(1) }.not_to raise_error
    end

    it 'can be done with first and second roll values' do
      expect{ Frame.new(1, 1) }.not_to raise_error
    end

    it 'is done with nil roll values for rolls by default' do
      expect(Frame.new.first).to eq nil
      expect(Frame.new.second).to eq nil
    end

    it 'can not be done with more than two rolls' do
      expect{ Frame.new(1, 1, 1) }.to raise_error(ArgumentError)
    end

    it 'can not be done with only a second roll' do
      arg_err_msg = 'Second roll must be nil if first is nil'
      expect{ Frame.new(nil, 1) }.to raise_error(ArgumentError, arg_err_msg)
    end

    it 'can only be done with 0-10 or nil for first roll' do
      arg_err_msg = 'First roll must be nil or number between 0-10'
      invalid_args.each do |arg|
        expect{ Frame.new(arg) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it 'can only be done with 0-10 or nil for second roll' do
      arg_err_msg = 'Second roll must be nil or number complementing first roll'
      invalid_args.each do |arg|
        expect{ Frame.new(0, arg) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it 'can be done with second roll value than complements the first' do
      expect{ Frame.new(1, 9) }.not_to raise_error
    end

    it 'can only be done with complementing first and second roll values' do
      arg_err_msg = 'Second roll must be nil or number complementing first roll'
      unmatched_rolls.each do |roll|
        expect{ Frame.new(*roll) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it "can be done with 'nc' value for second roll if first is a strike" do
      expect{ Frame.new(10, 'nc') }.not_to raise_error
    end

    it "can only be done with 'nc' value for second roll if first is a strike" do
      arg_err_msg = "Second roll must be 'nc' (not-counted) if first is a strike"
      [[10, nil], [10, 0]].each do |rolls|
        expect{ Frame.new(*rolls) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end
  end

  context 'After Initialization' do

    it 'knows the value of the first roll' do
      expect(regular_frame.first).to eq 1
    end

    it 'knows the value of the second roll' do
      expect(regular_frame.second).to eq 5
    end

    it 'knows the values rolls that were made' do
      expected_values = [[], [1], [1, 5], [5, 5], [10]]
      frames.each_with_index do |frame, index|
        expect(frame.values).to eq expected_values[index]
      end
    end

    it 'knows if rolls values represent a strike' do
      expect(strike_frame.strike?).to eq true
    end

    it 'knows if rolls values do not represent a strike' do
      frames[0..3].each do |frame|
        expect(frame.strike?).to eq false
      end
    end

    it 'knows if rolls values represent a spare' do
      expect(spare_frame.spare?).to eq true
    end

    it 'knows if rolls values do not represent a spare' do
      frames = [empty_frame, incomplete_frame, regular_frame, strike_frame]
      frames.each { |frame| expect(frame.spare?).to eq false }
    end

    it 'can return the base score of the rolls values' do
      expected_scores = [0, 1, 6, 10, 10]
      frames.each_with_index do |frame, index|
        expect(frame.score).to eq expected_scores[index]
      end
    end

    it "knows if it's empty" do
      expect(empty_frame.empty?).to be true
    end

    it "knows if it's not empty" do
      frames[1..4].each do |frame|
        expect(frame.empty?).to be false
      end
    end

    it "knows if it's incomplete" do
      [empty_frame, incomplete_frame].each do |frame|
        expect(frame.incomplete?).to be true
      end
    end

    it "knows if it's complete" do
      frames[2..4].each do |frame|
        expect(frame.incomplete?).to be false
      end
    end

    it 'can have 0-10 pins knocked on first roll' do
      (0..10).to_a.each do |num_of_pins|
        frame = Frame.new
        frame.roll(num_of_pins)
        expect(frame.first).to eq num_of_pins
      end
    end

    it 'can not have less than 0 pins knocked on first roll' do
      err_msg = 'First roll must be nil or number between 0-10'
      expect{ empty_frame.roll(-1) }.to raise_error(ArgumentError, err_msg)
    end

    it 'can not have more than 10 pins knocked on first roll' do
      err_msg = 'First roll must be nil or number between 0-10'
      expect{ empty_frame.roll(11) }.to raise_error(ArgumentError, err_msg)
    end

    it 'can have 0-10 pins knocked on second roll' do
      (0..10).to_a.each do |num_of_pins|
        frame = Frame.new(0)
        frame.roll(num_of_pins)
        expect(frame.second).to eq num_of_pins
      end
    end

    it 'can not have less than 0 pins knocked on second roll' do
      err_msg = 'Second roll must be nil or number complementing first roll'
      expect{ incomplete_frame.roll(-1) }.to raise_error(ArgumentError, err_msg)
    end

    it 'can not have more than 10 pins knocked on second roll' do
      err_msg = 'Second roll must be nil or number complementing first roll'
      expect{ incomplete_frame.roll(11) }.to raise_error(ArgumentError, err_msg)
    end

    it "marks second roll as 'nc' (not-counted) if first roll is a strike" do
      empty_frame.roll(10)
      expect(empty_frame.first).to eq 10
      expect(empty_frame.second).to eq 'nc'
    end
  end
end
