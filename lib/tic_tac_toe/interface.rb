require 'cli/ui'

module TicTacToe
  class Interface
    def new_game
      %(Welcome to Ruby Tic Tac Toe
Tic-tac-toe is a game for two players, X and O, who take turns
marking the spaces in a 3×3 grid. The player who succeeds in placing
three of their marks in a horizontal, vertical, or diagonal row is the winner.
Player One will be 'X' and Player Two will be 'O')
    end

    attr_reader :game_matrix

    def initialize(game_matrix)
      @game_matrix = game_matrix
    end

    # Checks If A Matrix Row Is Not Occupied (All Items Equal To 'O' Or 'X')
    # Example: [X, X, '-'], All Items Are Not Equal To Character '-', So The Row Is Available
    def available_game_board_rows
      game_matrix.map do |row|
        row.any? { |symbol| symbol == '-' }
      end
    end

    def select_option(player_symbol)
      player_selection = Struct.new(:column, :row).new

      options = %w[First Second Third].freeze

      CLI::UI::Prompt.ask("#{player_symbol}: What row would you like to select?") do |handler|
        available_game_board_rows.map.with_index do |move_available, index|
          if move_available == true
            handler.option(options[index]) do |selected_option|
              player_selection.row = options.index(selected_option)
            end
          end
        end
      end

      CLI::UI::Prompt.ask("#{player_symbol}: What column would you like to select?") do |handler|
        options.map do |option|
          handler.option(option) do |selected_option|
            player_selection.column = options.index(selected_option)
          end
        end
      end

      player_selection
    end

    def draw_board
      puts
      puts "#{game_matrix[0][0]} | #{game_matrix[0][1]} | #{game_matrix[0][2]}"
      puts '----------'
      puts "#{game_matrix[1][0]} | #{game_matrix[1][1]} | #{game_matrix[1][2]}"
      puts '----------'
      puts "#{game_matrix[2][0]} | #{game_matrix[2][1]} | #{game_matrix[2][2]}"
    end

    # def render_game(matrix)
    #   matrix.each_with_index.map do |row, index|
    #     "#{index + 1}  #{row}"
    #   end
    # end

    # puts render_game(game_state)
  end
end
