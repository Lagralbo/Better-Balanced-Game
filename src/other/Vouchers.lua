-- Magic Trick
SMODS.Voucher:take_ownership( 'magic_trick', {
    config = { extra = { rate = 4 } },
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.playing_card_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}, true)

SMODS.Voucher:take_ownership('illusion', {
    config = { extra = { base_rate = 4, extra_rate = 2.4, display = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.display} }
    end,
    calculate = function(self, card, context)
        if context.modify_shop_card and
            (context.card.ability.set == 'Enhanced' or context.card.ability.set == 'Default') then -- is a playing card
            if pseudorandom('BBG_illusion') > 0.7 then
                context.card:set_edition(SMODS.poll_edition { key = 'BBG_illusion_edition', no_negative = true, guaranteed = true })
            end
        end
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.playing_card_rate = card.ability.extra.base_rate * card.ability.extra.extra_rate
                return true
            end
        }))
    end,
}, true)