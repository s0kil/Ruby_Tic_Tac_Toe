require 'curses'
require 'strings'

#   Curses Library Resources
#   - https://github.com/ruby/curses
#   - https://atevans.com/2017/08/02/ruby-curses-for-terminal-apps.html
#   - https://www.2n.pl/blog/basics-of-curses-library-in-ruby-make-awesome-terminal-apps
#   - https://stac47.github.io/ruby/curses/tutorial/2014/01/21/ruby-and-curses-tutorial.html

module TicTacToe
  module Interface
    # TUI
    class TextualInterface
      attr_accessor :game_board, :window

      def initialize(game_board)
        @game_board = game_board

        Curses.init_screen
        Curses.start_color
        Curses.curs_set(0) # Set Curser Invisible
        Curses.noecho # Do Not Echo Entered Keys

        @window = Curses::Window.new(0, 0, 2, 2) # Full Screen, With Some Margin
        @window.nodelay = true # Do Not Block Waiting For Keyboard Input With `getch`
        @window.refresh
      end

      def new_game
        welcome_message = %(Welcome to Ruby Tic Tac Toe
Tic-tac-toe is a game for two players, X and O, who take turns marking the spaces in a 3×3 grid.
The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.
Player One will be 'X' and Player Two will be 'O'
)

        window << Strings.wrap(welcome_message, 60)
      end

      def start_game_loop(&block)
        window << 'Starting Game...'

        loop do # Render Loop
          block.call
          window.refresh
        end
      rescue Interrupt => _e
        # Handling Ctrl+C, No Operation
        # Continue With Default Of Exiting The Program
      end

      def draw_board
        # TODO: How To Render In Free Space (After Welcome Message)? Versus Gusssing The Correct Hardcoded Value
        window.setpos(8, 0)

        window << "#{game_board[0][0]} | #{game_board[0][1]} | #{game_board[0][2]}\n"
        window << "---------\n"
        window << "#{game_board[1][0]} | #{game_board[1][1]} | #{game_board[1][2]}\n"
        window << "---------\n"
        window << "#{game_board[2][0]} | #{game_board[2][1]} | #{game_board[2][2]}\n"

        Curses.curs_set(2) # Cursor Is Now Visible
      end

      def close_screen
        Curses.close_screen
      end
    end
  end
end
