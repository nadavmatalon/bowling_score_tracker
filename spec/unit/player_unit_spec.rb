describe Player do

  let (:player) { Player.new }

  context 'During Initialization' do

    it 'can be initialized with a name' do
      expect(Player.new('test_name').name).to eq 'test_name'
    end

    it "is initialized with the name 'dude' by defualt" do
      expect(player.name).to eq 'dude'
    end

    it 'is initialized with an new scoresheet' do
      expect(player.scoresheet.class).to eq ScoreSheet
    end
  end

  context 'After Initialization' do

    context 'Rolls' do

      it 'can make a gutter role' do
        expect{ player.roll(0) }.not_to raise_error
      end

      it 'can make an average role' do
        expect{ player.roll(4) }.not_to raise_error
      end

      it 'can make a strike role' do
        expect{ player.roll(10) }.not_to raise_error
      end
    end

    context 'All Frames' do

      it 'knows if all frames have not been played' do
        expect(player.done?).to be false
      end

      it 'knows if all frames have been played' do
        20.times { player.roll(1) }
        expect(player.done?).to be true
      end
    end

    context 'Bonus Frames' do

      it "knows if it's currently not playing bonus frames" do
        expect(player.in_bonus?).to be false
      end

      it "knows if it's currently playing bonus frames" do
        10.times { player.roll(10) }
        expect(player.in_bonus?).to be true
        player.roll(1)
        expect(player.in_bonus?).to be true
      end
    end

    context 'Score' do

      it "knows it's score before frames have been played" do
        expect(player.score).to eq 0
      end

      it "knows it's score after one roll has been made" do
        player.roll(7)
        expect(player.score).to eq 7
      end

      it "knows it's score after one frame has been played" do
        2.times { player.roll(4) }
        expect(player.score).to eq 8
      end
    end
  end
end
