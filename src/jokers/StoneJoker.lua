SMODS.Joker:take_ownership('stone', 
 {
    name = "BBG_stone",
    config = { extra = { chips = 50} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips} }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            SMODS.has_enhancement(context.other_card, 'm_stone') then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,


}, true)