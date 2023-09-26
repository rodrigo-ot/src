#Fator RH:
#V = jarValue / (decisionsBetRaise + 1) * contRemainingPlayers * contDontChooseRun * (contDecisionRaise + 1)
#T = 1
#Porcentagem de decisões que vão ser tomadas:
#D1(Fugir) se V < T
#D2(Continuar no Jogo) se T <= V < 20 * T
#D3(Aumentar Pouco) se 20 * T <= V < 50 * T
#D4(Aumentar Médio) se 50 * T <= V < 100 * T
#D5(Aumentar Muito) se 100 * T <= V < 1000 * T
#D6(Aumentar Tudo) se V >= 1000 * T

class PlayerBot < Player
    T = 1
    
    def chooseAction(jarValue : Int32, contDecisionsBetRaise : Int32, contRemainingPlayers : Int32, contDontChooseFold : Int32, contRaise : Int32)
        #conta para definir a jogada
        decisionBot = (jarValue) / (contDecisionsBetRaise + 1) * contRemainingPlayers * contDontChooseFold * (contRaise + 1)
        if decisionBot < T
            decisionBot = 1
        elsif T <= decisionBot < 20 * T
            decisionBot = 2
        elsif 20 * T <= decisionBot < 50 * T
            decisionBot = 3
        elsif 50 * T <= decisionBot < 100 * T
            decisionBot = 4
        elsif 100 * T <= decisionBot < 1000 * T
            decisionBot = 5
        elsif decisionBot >= 1000 * T
            decisionBot = 6
        end
            
        case decisionBot
        when 1
            #retorna a jogada Fold
            return 1
        when 2
            #retorna a jogada Check
            return 2
        when 3
            #retorna a jogada Bet(Jogada mínima)
            return 3
        when 4
            #retorna a jogada Bet(Jogada mínima * 2)
            return 4
        when 5
            #retorna a jogada Bet(Jogada mínima * 3)
            return 5
        when 6
            #retorna a jogada All-In(Aposta todas as fichas restantes)
            return 6
        end
    end
end