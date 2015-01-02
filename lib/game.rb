require 'json'
require_relative 'player'

class Game

  MAX_PLAYERS = 4

  attr_reader :players, :current_player

  def initialize(num_of_players = 1)
    fail(ArgumentError, arg_err_msg) unless match_max(num_of_players)
    @players = create_players(num_of_players)
    @current_player = players.first
  end

  def player_roll(num_of_pins)
    game_data, player_frame = {}, current_frame
    game_data['player_name'] = player_name
    game_data['player_frame'] = player_frame
    play_roll(num_of_pins)
    game_data['player_score'] = player_score
    game_data['player_roll'] = roll_index
    check_switch_turn(player_frame.to_i)
    game_data['available_rolls'] = available_rolls
    game_data.to_json
  end

  def play_roll(num_of_pins)
    current_player.roll(num_of_pins)
  end

  def check_switch_turn(frame_before_roll)
    return false if current_player.in_bonus? || single_player
    switch_turn if (frame_before_roll != current_frame.to_i)
  end

  def switch_turn
    @current_player = @players.rotate!.first
  end

  def match_max(num_of_players)
    (1..MAX_PLAYERS).include?(num_of_players)
  end

  def create_players(num_of_players)
    (1..num_of_players).map.with_index do |_, index|
      Player.new(player_names[index])
    end
  end

  def player_name
    current_player.name
  end

  def roll_index
    current_player.current_roll
  end

  def player_score
    current_player.score
  end

  def current_frame
    current_player.current_frame.to_s
  end

  def available_rolls
    rolls = current_player.available_rolls
    rolls ? rolls.map { |roll| format(roll) } : []
  end

  def single_player
    players.count == 1
  end

  def format(roll)
    '#rolls-btn-' + roll.to_s
  end

  def player_names
    %w(one two three four)
  end

  def arg_err_msg
    'Argument must be Fixnum between 1-4'
  end
end
