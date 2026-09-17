SMODS.Joker:take_ownership('hanging_chad', 
 {
    name = "BBG_hanging_chad",
    rarity = 1,
    
    config = { extra = { repetitions = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,

    calculate = function (self, card, context)
        if context.repetition and context.cardarea == G.play and #context.scoring_hand >= 3 and context.other_card == context.scoring_hand[3] then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}, true)
