"use strict";

(function() {

  $.ajaxSetup ({
    cache: false
  });
 
  $('.num-of-players-btn').click(function() {
    var selectedButton = this.value;
    $.post('/new-game', 
      {
        num_of_players: selectedButton
      }).success(function() {
        $('#num-of-players-main').fadeOut(200, function() {
          $('#rolls-main').fadeIn(200);
          for(var index = 1; index <= selectedButton; index += 1) {
            $('#rolls-main').css('text-align', 'left');
            $('#Scoresheet-Player-' + index).fadeIn(200);
          }
        });
      });
  });

  $('.rolls-btn').click(function() {
    var selectedButton = this.value,
        game_data, 
        player_name,
        player_roll,
        player_frame,
        player_score,
        available_rolls
    $.post('/roll',
      {
        num_of_pins: selectedButton
      }, function(data) {
        game_data = jQuery.parseJSON(data);
        player_name = game_data.player_name
        player_roll = game_data.player_roll
        player_frame = game_data.player_frame
        player_score = game_data.player_score
        available_rolls = game_data.available_rolls
      },'text').success(function() {
        $('#' + player_name + player_roll).text(selectedButton);
        $('#' + player_name + 'F' + player_frame).text(player_score);
        $('#' + player_name + 'T').text(player_score);
        $('.rolls-btn').hide();
        $.each(available_rolls, function(index, roll) {
          $(roll).fadeIn(150);
        });
        if (available_rolls.length === 0) {
          $('#rolls-main').css('text-align', 'center');
          $('#new-game-btn').fadeIn(200);
        }
    });
  });

  $('#new-game-btn').click(function() {
    location.reload();
  });

  $(document).ready(function() {
    $('#page-main-container').fadeIn(300);
  });

})();
