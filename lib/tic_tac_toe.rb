require_relative 'tic_tac_toe/interface.rb'
require_relative 'tic_tac_toe/game.rb'

module TicTacToe
  @game_board = Matrix.build(3, 3) { |_row, _col| '-' }.to_a

  def self.start_game(
    game = TicTacToe::Game.new(@game_board),
    interface = TicTacToe::Interface.new(@game_board)
  )
    players = %w[X O].freeze

    puts interface.new_game

    # TODO: Game Logic To Check For Winner
    winner = false

    # Infinite Loop Until We Have A Winner
    until winner
      players.map do |player|
        interface.draw_board
        puts "\nPlayer #{player}, Select Your Move!"
        player_selection = interface.select_option(player)
        game.update_board(player_selection, player)
      end
    end
  end
end