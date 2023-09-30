require "./holdem/Card.cr"
require "./holdem/Player.cr"
require "./holdem/enums/suit.cr"
require "./holdem/enums/Function.cr"
require "./holdem/enums/rank.cr"
require "./holdem/PlayerBot.cr"
require "./holdem/PokerGame.cr"

game = PokerGame.new(2, 10)
game.startGame()


# a = [1,2,3]

# b = a

# b.pop(2)
# p a