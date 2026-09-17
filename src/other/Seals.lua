SMODS.Seal:take_ownership('Blue', {
    name = 'BBG_blue_seal',
    config = { extra = { odds = 2} },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, self.config.extra.odds, 'BBG_blue_seal')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.hand and #context.scoring_hand >= 5 and not context.end_of_round 
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and SMODS.pseudorandom_probability(card, 'BBG_blue_seal', 1, card.ability.seal.extra.odds) then

            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
    end
}, true)