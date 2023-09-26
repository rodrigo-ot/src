#Fator RH:
#V = jarValue / (decisionsBetRaise + 1) * contRemainingPlayers * contDontChooseRun * (contDecisionRaise + 1)

class PlayerBot < Player
    property jarValue = 0
    property decisionsBetRaise = 0
    property contRemainingPlayers = 0
    property contDontChooseFold = 0
    property contDecisionRaise = 0

    