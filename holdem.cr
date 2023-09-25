require "./holdem/Card.cr"
require "./holdem/Player.cr"
require "./holdem/enums/suit.cr"
require "./holdem/enums/rank.cr"
require "./holdem/PokerGame.cr"

game = PokerGame.new(2)
puts(game.players)