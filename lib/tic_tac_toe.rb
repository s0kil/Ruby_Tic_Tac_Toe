require_relative 'tic_tac_toe/interface/tui_interface.rb'
require_relative 'tic_tac_toe/game.rb'

module TicTacToe
  @game_board = Matrix.build(3, 3) { |_row, _col| '-' }.to_a
  @player_selection = Struct.new(:column, :row).new

  def self.start_game(
    game = TicTacToe::Game.new(@game_board, @player_selection),
    interface = TicTacToe::Interface::TextualInterface.new(@game_board, @player_selection)
  )
    # players = %w[X O].freeze

    interface.new_game
    interface.start_game_loop do
      interface.draw_board
      interface.handle_key_press

      # Update Game Board If Player Selected An Item
      game.update_board('+') if @player_selection.row && @player_selection.column

      # TODO: Check For Winner
    end

    # TODO: Game Logic To Check For Winner
    # winner = false

    # Infinite Loop Until We Have A Winner
    # until winner
    #   players.map do |player|
    #     interface.draw_board
    #     puts "\nPlayer #{player}, Select Your Move!"
    #     player_selection = interface.select_option(player)
    #     game.update_board(player_selection, player)
    #   end
    # end
  end
end
