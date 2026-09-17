SMODS.Joker:take_ownership('bootstraps', 
 {
    name = "BBG_bootstraps",
    config = { extra = { xMult = 4} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xMult} }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xMult
            }
        end
        if context.before and G.GAME.hands[context.scoring_name].level > 1 then
            return {
                        level_up = -1
        }
        end
    end,
 }, true)