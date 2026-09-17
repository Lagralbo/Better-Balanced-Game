 SMODS.Joker:take_ownership('gros_michel',
 {
    name = "BBG_gros_michel",
    config = { extra = { odds = 6, mult = 12 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bbg_gros_michel')
        return { vars = { card.ability.extra.mult, numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'bbg_gros_michel', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.bbg_gros_michel_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `no_pool_flag = 'bbg_gros_michel_extinct'`
        return not G.GAME.pool_flags.bbg_gros_michel_extinct
    end
 }, true)


 SMODS.Joker:take_ownership('cavendish',
 {
    name = "BBG_Cavendish",
    config = { extra = { odds = 1000, Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bbg_cavendish')
        return { vars = { card.ability.extra.Xmult, numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'bbg_cavendish', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `yes_pool_flag = 'bbg_gros_michel_extinct'`
        return G.GAME.pool_flags.bbg_gros_michel_extinct
    end
}, true)