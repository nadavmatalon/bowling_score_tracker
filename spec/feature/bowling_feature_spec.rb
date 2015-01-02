describe Game, type: :feature  do

  subject { page }

  before { visit '/' }

  context 'on page upload' do

    it "should have the title 'Bowling Score Tracker'" do
      should have_title 'Bowling Score Tracker'
    end

    it "should show the page title 'Bowling Score Tracker'" do
      should have_content 'Bowling Score Tracker'
    end

    it 'should show the select number of players pane' do
      should have_selector :xpath, "//div[@id='num-of-players-main']"
    end

    it 'should show the four number of players selection buttons' do
      should have_selector :xpath, "//button[@class='num-of-players-btn']", count: 4
    end
  end

  context 'After Selecting Single Player Mode' do

    before (:each) do
      within('#num-of-players-btn-contaimer') { click_button '1' }
    end

    it 'should show the 11 possible rolls buttons' do
      within '#rolls-main' do
        should have_selector :xpath, "//button[@class='rolls-btn']", count: 11, visible: true
      end
    end

    it 'should show player one scoresheet' do
      within '.scoresheets-main' do
        should have_selector :xpath, "//div[@id='Scoresheet-Player-1']", count: 1, visible: true
      end
    end

    it 'should not show the other players scoresheets' do
      within '.scoresheets-main' do
        for index in 2..4
          should have_selector :xpath, "//div[@id='Scoresheet-Player-#{index}']", visible: false
        end
      end
    end

    it 'should show the name of player one' do
      within('#Scoresheet-Player-1') { should have_content 'Player One' }
    end

    it 'should show the initial score of player one' do
      within('#oneT') { should have_content '0' }
    end

    context 'After Clicking A First Roll Button' do

      before (:each) { within('#rolls-main') { click_button '1' } }

      it 'should show the remaining possible rolls buttons' do
        within '#rolls-main' do
          should have_selector :xpath, "//button[@class='rolls-btn']", count: 10, visible: true
          should have_selector :xpath, "//button[@id='rolls-btn-10']", count: 1, visible: false
        end
      end

      it 'should show the updated score of player one' do
        within('#oneT') { should have_content '1' }
      end
    end

    context 'After Clicking A Second Roll Button' do

      before (:each) do
        within('#rolls-main') { 2.times { click_button '1' } }
      end

      it 'should show all the possible rolls buttons' do
        within '#rolls-main' do
          should have_selector :xpath, "//button[@class='rolls-btn']", count: 11, visible: true
        end
      end

      it 'should show the updated score of player one' do
        within ('#oneT') { should have_content '2' }
      end
    end
  end

  context 'After Selecting Two Players Mode' do

    before (:each) do
      within('#num-of-players-btn-contaimer') { click_button '2' }
    end

    it 'should show players one and two scoresheets' do
      within '.scoresheets-main' do
        for index in 1..2
          should have_selector :xpath, "//div[@id='Scoresheet-Player-#{index}']", count: 1, visible: true
        end
      end
    end

    it 'should not show the other players scoresheets' do
      within '.scoresheets-main' do
        for index in 3..4
          should have_selector :xpath, "//div[@id='Scoresheet-Player-#{index}']", visible: false
        end
      end
    end

    it 'should show the names of players one and two' do
      ['Player One', 'Player Two'].each.with_index(1) do |player_name, index|
        within("#Scoresheet-Player-#{index}") { should have_content player_name }
      end
    end

    it 'should show the initial score of players one and two' do
      ['#oneT', '#twoT'].each do |player_pane|
        within(player_pane) { should have_content '0' }
      end
    end
  end

  context 'After Selecting Three Players Mode' do

    before (:each) do
      within('#num-of-players-btn-contaimer') { click_button '3' }
    end

    it 'should show players one, two and three scoresheets' do
      within '.scoresheets-main' do
        for index in 1..3
          should have_selector :xpath, "//div[@id='Scoresheet-Player-#{index}']", count: 1, visible: true
        end
      end
    end

    it 'should not show player four scoresheet' do
      within '.scoresheets-main' do
        should have_selector :xpath, "//div[@id='Scoresheet-Player-4']", visible: false
      end
    end

    it 'should show the names of players one, two and three' do
      ['Player One', 'Player Two', 'Player Three'].each.with_index(1) do |player_name, index|
        within("#Scoresheet-Player-#{index}") { should have_content player_name }
      end
    end

    it 'should show the initial score of players one, two and three' do
      ['#oneT', '#twoT', '#threeT'].each do |player_pane|
        within(player_pane) { should have_content '0' }
      end
    end
  end

  context 'After Selecting Four Players Mode' do

    before (:each) do
      within('#num-of-players-btn-contaimer') { click_button '4' }
    end

    it 'should show all players scoresheets' do
      within '.scoresheets-main' do
        for index in 1..4
          should have_selector :xpath, "//div[@id='Scoresheet-Player-#{index}']", count: 1, visible: true
        end
      end
    end

    it 'should show the names of all players' do
      player_names = ['Player One', 'Player Two', 'Player Three', 'Player Four']
      player_names.each.with_index(1) do |player_name, index|
        within("#Scoresheet-Player-#{index}") { should have_content player_name }
      end
    end

    it 'should show the initial score of all players' do
      ['#oneT', '#twoT', '#threeT', '#fourT'].each do |player_pane|
        within(player_pane) { should have_content '0' }
      end
    end
  end

  context 'Switch Turns' do

    it "should switch turns between players after frame's rolls are complete" do
      within('#num-of-players-btn-contaimer') { click_button '2' }
      within '#rolls-main' do
        2.times { click_button '1' }
        click_button '5'
      end
      within('#twoT') { should have_content '5' }
    end
  end

  context 'New Game' do

    before (:each) do
      within('#num-of-players-btn-contaimer') { click_button '1' }
    end

    it 'should not show new game button until all frames are played' do
      should have_button 'New Game', visible: false
    end

    it 'should show new game button after all frames are played' do
      within('#rolls-main') { 12.times { click_button '10' } }
      should have_button 'New Game', visible: true
    end

    it 'should start a new game if new game button is clicked' do
      should have_selector :xpath, "//div[@id='num-of-players-main']", visible: false
      within('#rolls-main') { 12.times { click_button '10' } }
      click_button 'New Game'
      should have_selector :xpath, "//div[@id='num-of-players-main']", visible: true
    end
  end
end
