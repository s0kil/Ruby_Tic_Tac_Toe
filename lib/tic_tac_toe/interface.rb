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

    # Checks If A Matrix Row Is Not Occupied (All Items Not Equal To 'O' Or 'X')
    # Example: [X, X, '-'], All Items Are Not Equal To Character '-', So The Row Is Available
    def available_game_board_rows
      game_matrix.map do |row|
        row.any? { |symbol| symbol == '-' }
      end
    end

    def available_game_board_columns(selected_row)
      # ['X','-','-'] -> [false, true, true]
      selected_row.map { |item| item == '-' }
    end

    def player_prompt(player_selection, row_or_column, symbol, available_moves)
      options = %w[First Second Third].freeze

      begin
        CLI::UI::Prompt.ask("#{symbol}: What #{row_or_column} would you like to select?") do |handler|
          available_moves.map.with_index do |move_available, index|
            if move_available == true
              handler.option(options[index]) do |selected_option|
                player_selection[row_or_column] = options.index(selected_option)
              end
            end
          end
        end
      rescue Interrupt # https://github.com/Shopify/cli-ui/blob/master/lib/cli/ui/prompt/interactive_options.rb#L254-L257
        puts 'Leaving Ruby Tic Tac Toe, Goodbye!'
        exit
      end
    end

    def select_option(player_symbol)
      player_selection = Struct.new(:column, :row).new

      player_prompt(player_selection, 'row', player_symbol, available_game_board_rows)

      selected_row = game_matrix[player_selection.row]
      available_columns = available_game_board_columns(selected_row)
      player_prompt(player_selection, 'column', player_symbol, available_columns)

      player_selection
    end

    def draw_board
      puts
      puts "#{game_matrix[0][0]} | #{game_matrix[0][1]} | #{game_matrix[0][2]}"
      puts '---------'
      puts "#{game_matrix[1][0]} | #{game_matrix[1][1]} | #{game_matrix[1][2]}"
      puts '---------'
      puts "#{game_matrix[2][0]} | #{game_matrix[2][1]} | #{game_matrix[2][2]}"
    end
  end
end
