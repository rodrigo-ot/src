require "./holdem/Card.cr"
require "./holdem/Player.cr"
require "./holdem/enums/suit.cr"
require "./holdem/enums/Function.cr"
require "./holdem/enums/rank.cr"
require "./holdem/PlayerBot.cr"
require "./holdem/PokerGame.cr"

# puts(game.players)


# jogador = Player.new(true, "rodris")
# jogador.give_card(Card.new(Suit.new(0), 13))
# jogador.give_card(Card.new(Suit.new(1), 13))
# jogador.give_card(Card.new(Suit.new(2), 13))
# puts(jogador.showHand.to_s)

game = PokerGame.new(2, 10)
game.startGame()