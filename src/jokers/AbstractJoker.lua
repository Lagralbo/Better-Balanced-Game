SMODS.Joker:take_ownership('abstract', 
 {
    name = "BBG_abstract",
    config = { extra = { mult = 3} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult * (#G.jokers.cards - 1)  } }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * (#G.jokers.cards - 1)
            }
        end
    end

    }, true)
