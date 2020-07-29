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

    def select_option
      player_selection = Struct.new(:column, :row).new

      options = %w[First Second Third].freeze

      CLI::UI::Prompt.ask('What column would you like to select?') do |handler|
        options.map do |option|
          handler.option(option) do |selected_option|
            player_selection.column = options.index(selected_option)
          end
        end
      end

      CLI::UI::Prompt.ask('What row would you like to select?') do |handler|
        options.map do |option|
          handler.option(option) do |selected_option|
            player_selection.row = options.index(selected_option)
          end
        end
      end

      player_selection
    end

    def draw_board(matrix)
      puts
      puts "#{matrix[0][0]} | #{matrix[0][1]} | #{matrix[0][2]}"
      puts "----------"
      puts "#{matrix[1][0]} | #{matrix[1][1]} | #{matrix[1][2]}"
      puts "----------"
      puts "#{matrix[2][0]} | #{matrix[2][1]} | #{matrix[2][2]}"
    end


    # def render_game(matrix)
    #   matrix.each_with_index.map do |row, index|
    #     "#{index + 1}  #{row}"
    #   end
    # end

    # puts render_game(game_state)
  end
end
