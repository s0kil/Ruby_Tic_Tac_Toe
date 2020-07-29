require_relative 'tic_tac_toe/interface.rb'
require_relative 'tic_tac_toe/game.rb'

module TicTacToe
  
  @@game_board = Matrix.build(3, 3) { |_row, _col| '-' }.to_a

  def self.start_game(
    game = TicTacToe::Game.new(@@game_board),
    interface = TicTacToe::Interface.new(@@game_board)
  )

    puts interface.new_game

    # TODO: Game Logic To Check For Winner
    winner = false

    # Infinite Loop Until We Have A Winner
    until winner
      interface.draw_board
      puts "\nPlayer X, Select Your Move!"
      player_x = interface.select_option
      game.update_board(player_x, 'X')

      interface.draw_board
      puts "\nPlayer O, Select Your Move!"
      player_o = interface.select_option
      game.update_board(player_o, 'O')
    end
  end
end
