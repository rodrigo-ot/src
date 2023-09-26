require "./holdem/Card.cr"
require "./holdem/Player.cr"
require "./holdem/enums/suit.cr"
require "./holdem/enums/Function.cr"
require "./holdem/enums/rank.cr"
require "./holdem/PokerGame.cr"

# game = PokerGame.new(2)
# puts(game.players)


jogadores = [
    Player.new(false),Player.new(false),Player.new(false),Player.new(false)
]
jogadores[2].setFunction(Function::Dealer)
puts jogadores.index {|player| player.getFunction == Function::Dealer}
jogadores.rotate!(2)
puts jogadores.index {|player| player.getFunction == Function::Dealer}