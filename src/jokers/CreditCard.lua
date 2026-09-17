SMODS.Joker:take_ownership('credit_card', 
 {
    name = "BBG_credit_card",
    config = { extra = { dollars = 15, dollar_loss = 20} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollar_loss } }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
                return {
                    dollars = -card.ability.extra.dollar_loss,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true end
                        }))
                    end    
                }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
         G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            delay = 0.2,
            func = function()

                ease_dollars(card.ability.extra.dollars)
                return true
            end 
        }))
        --G.GAME.dollars = G.GAME.dollars + card.ability.extra.dollars

    end
 }, true)