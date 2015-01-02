describe Game do

  let (:game) { Game.new }
  let (:one_player_game) { Game.new(1) }
  let (:two_player_game) { Game.new(2) }
  let (:four_player_game) { Game.new(4) }

  context 'Initialization' do

    it 'can be done without number of players' do
      expect{ Game.new }.not_to raise_error
    end

    it 'can be done with number of players' do
      expect{ Game.new(1) }.not_to raise_error
    end

    it 'is done with one player by default' do
      expect(Game.new.players.count).to eq 1
    end

    it 'can be done with one player' do
      expect{ one_player_game }.not_to raise_error
    end

    it 'can be done with four players' do
      expect{ four_player_game }.not_to raise_error
    end

    it 'can only be done with minimum of one player' do
      err_msg = 'Argument must be Fixnum between 1-4'
      expect{ Game.new(0) }.to raise_error(ArgumentError, err_msg)
    end

    it 'can only be done with maximim of one player' do
      err_msg = 'Argument must be Fixnum between 1-4'
      expect{ Game.new(5) }.to raise_error(ArgumentError, err_msg)
    end

    it 'is done with first player as current player by default' do
      expect( game.current_player.name ).to eq 'one'
    end
  end

  context 'After Initialization' do

    it 'can switch turn from first to second player' do
      two_player_game.switch_turn
      expect(two_player_game.current_player.name).to eq 'two'
    end

    it 'can switch turns by cycling through all players' do
      names = %w(one two three four one)
      5.times.with_index do |index|
        expected_name = "#{names[index]}"
        expect(four_player_game.current_player.name).to eq expected_name
        four_player_game.switch_turn
      end
    end
  end
end
