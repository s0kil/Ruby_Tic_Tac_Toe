require_relative 'tic_tac_toe/interface/tui_interface.rb'
require_relative 'tic_tac_toe/game.rb'

module TicTacToe
  @game_board = Matrix.build(3, 3) { |_row, _col| '-' }.to_a
  @player_selection = Struct.new(:column, :row).new
  @current_player = ''

  def self.start_game(
    game = TicTacToe::Game.new(@game_board, @player_selection),
    interface = TicTacToe::Interface::TextualInterface.new(@game_board, @player_selection)
  )
    game_characters = %w[X O].freeze

    interface.new_game

    winner = false

    interface.game_loop do
      # If New Game, Set Current Player To Random Game Character
      @current_player = game_characters.sample if @current_player.empty?

      # Update Game Board Item And Switch Player,
      # If Player Selected An Item,
      # And The Item Is Available
      if @player_selection.row &&
         @player_selection.column &&
         @current_player.empty? == false &&
         game.player_selection_available? == true

        game.update_board(@current_player)

        if game.winner?
          winner = true
          interface.winner_message(@current_player)
        end

        # Switch Players
        new_player =
          game_characters.reject { |game_character| game_character == @current_player }.first

        @current_player = new_player

        # Reset Player Selection
        @player_selection.row = nil
        @player_selection.column = nil
      end

      unless winner
        interface.draw_board(@current_player)
        interface.handle_key_press
      end

      # TODO: Game Logic To Check For Winner
    end
  end
end
