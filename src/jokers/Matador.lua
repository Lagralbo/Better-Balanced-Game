SMODS.Joker:take_ownership('matador', 
 {
    name = "BBG_matador",
    config = { extra = { dollars = 4, size = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = { card.ability.extra.dollars, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.before and #context.full_hand == card.ability.extra.size  and G.GAME.blind.boss then
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end,
    generate_ui = SMODS.Joker.generate_ui,

}, true)