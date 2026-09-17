SMODS.Joker:take_ownership('loyalty_card', 
 {
    name = "BBG_loyalty_card",
    blueprint_compat = false,
    config = { extra = {every = 4, loyalty_remaining = 4 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_voucher', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        return {
            vars = {
     --return { vars = { localize { type = 'name_text', set = 'Tag', key = 'tag_double' } } }
                localize { type = 'name_text', set = 'Tag', key = 'tag_voucher' },
                localize { type = 'name_text', set = 'Tag', key = 'tag_coupon' },
                card.ability.extra.every +1,
                localize { type = 'variable', key = ('loyalty_inactive'), vars = { card.ability.extra.loyalty_remaining+1} }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.open_booster then
            if card.ability.extra.loyalty_remaining <= 0 then
                card.ability.extra.loyalty_remaining = card.ability.extra.every
                --SMODS.add_voucher_to_shop()
                return {
                        message = localize('b_redeem'),
                        func = function ()
                            G.E_MANAGER:add_event(Event({
                                trigger = "after",
                                delay = 0.8,
                                func = (function()
                                    add_tag({ key = 'tag_voucher' })
                                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                    return true
                                end)
                                }))
                                G.E_MANAGER:add_event(Event({
                                trigger = "after",
                                delay = 1.2,
                                func = (function()
                                    add_tag({ key = 'tag_coupon' })
                                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                    return true                         
                                end)
                            }))
                        end
                    }
            else 
                card.ability.extra.loyalty_remaining = card.ability.extra.loyalty_remaining -1
            end
        end

        if context.ending_booster and card.ability.extra.loyalty_remaining == 0 then
            local eval = function(card) return card.ability.extra.loyalty_remaining == 0 end
            juice_card_until(card, eval, true)
        end
    end
}, true)