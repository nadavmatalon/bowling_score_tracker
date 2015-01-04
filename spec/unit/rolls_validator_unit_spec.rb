describe RollsValidator do

  let (:empty_rolls)   { RollsValidator.new }
  let (:regular_rolls) { RollsValidator.new(1, 5) }
  let (:spare_rolls)   { RollsValidator.new(5, 5) }
  let (:strike_rolls)  { RollsValidator.new(10, 'nc') }
  let (:rolls) {
    [
      empty_rolls,
      regular_rolls,
      spare_rolls,
      strike_rolls
    ]
  }
  let (:invalid_args)  {
    [
      -1, 11, '1', :a, [1], { 'a' => 1 }
    ]
  }
  let (:incompatible_rolls) {
    [
      [2, 9], [3, 8],
      [4, 7], [5, 6],
      [6, 5], [7, 4],
      [8, 3], [9, 2]
    ]
  }

  context 'In General' do
    it 'knows that the value of a STRIKE is 10' do
      expect(RollsValidator::STRIKE).to eq 10
    end
  end

  context 'Initialization' do

    it 'can be done without roll values' do
      expect{ RollsValidator.new }.not_to raise_error
    end

    it 'can be done with a first roll value' do
      expect{ RollsValidator.new(1) }.not_to raise_error
    end

    it 'can be done with first and second roll values' do
      expect{ RollsValidator.new(1, 1) }.not_to raise_error
    end

    it 'is done with nil values for first and second rolls by default' do
      expect(RollsValidator.new.first).to eq nil
      expect(RollsValidator.new.second).to eq nil
    end

    it 'can not be done with more than two rolls' do
      expect{ RollsValidator.new(1, 1, 1) }.to raise_error(ArgumentError)
    end

    it 'can not be done with only a second roll' do
      arg_err_msg = 'Second roll must be nil if first is nil'
      expect{ RollsValidator.new(nil, 1) }.to raise_error(ArgumentError, arg_err_msg)
    end

    it "can not be done if first roll is a strike and second is not 'nc'" do
      err_msg = "Second roll must be 'nc' (not-counted) if first is a strike"
      expect{ RollsValidator.new(10, 0) }.to raise_error(ArgumentError, err_msg)
    end

    it 'can only be done with 0-10 or nil for first roll' do
      arg_err_msg = 'First roll must be nil or number between 0-10'
      invalid_args.each do |arg|
        expect{ RollsValidator.new(arg) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it 'can be done with second roll value than complements the first' do
      expect{ RollsValidator.new(1, 9) }.not_to raise_error
    end

    it 'can only be done with second roll value that complements the first' do
      arg_err_msg = 'Second roll must be nil or number complementing first roll'
      invalid_args.each do |arg|
        expect{ RollsValidator.new(0, arg) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it 'can only be done with complementing first and second roll values' do
      arg_err_msg = 'Second roll must be nil or number complementing first roll'
      incompatible_rolls.each do |roll|
        expect{ RollsValidator.new(*roll) }.to raise_error(ArgumentError, arg_err_msg)
      end
    end

    it "can be done with 'bonus ball' values (first = 'nil', second = 'nc')" do
      expect{ RollsValidator.new(nil, 'nc') }.not_to raise_error
    end
  end

  context 'After Initialization' do

    it 'knows if rolls are valid' do
      rolls.each do |roll|
        expect(roll.valid?).to be true
      end
    end

    it 'knows if rolls are not valid' do
      incompatible_rolls.each do |roll|
        expect{ RollsValidator.validate(roll) }.to raise_error(ArgumentError)
      end
    end

    it 'knows if first roll is in range' do
      (0..9).map { |roll| [roll] }.push([10, 'nc']).each do |first_roll|
        rolls = RollsValidator.new(*first_roll)
        expect(rolls.first_in_range?).to be true
      end
    end

    it 'knows if first roll is not in range' do
      err_msg = 'First roll must be nil or number between 0-10'
      [-1, 11].each do |roll|
        expect{ RollsValidator.validate(roll, 0) }.to raise_error(ArgumentError, err_msg)
      end
    end

    it 'knows if second roll is in range' do
      (0..10).to_a.push(nil).each do |second_roll|
        rolls = RollsValidator.new(0, second_roll)
        expect(rolls.second_in_range?).to be true
      end
    end

    it 'knows if second roll is not in range' do
      err_msg = 'Second roll must be nil or number complementing first roll'
      [-1, 11].each do |roll|
        expect{ RollsValidator.validate(0, roll) }.to raise_error(ArgumentError, err_msg)
      end
    end

    it 'knows which rolls are legitimate for first roll' do
      validator = RollsValidator.new
      expect(validator.legit_rolls).to eq (0..10).to_a
    end

    it 'knows which rolls are legitimate for second roll' do
      first_rolls = [[0], [9], [10, 'nc']]
      expected_results = [(0..10).to_a, [0, 1], []]
      first_rolls.each_with_index do |first_roll, index|
        validator = RollsValidator.new(*first_roll)
        expect(validator.legit_rolls).to eq expected_results[index]
      end
    end
  end
end
