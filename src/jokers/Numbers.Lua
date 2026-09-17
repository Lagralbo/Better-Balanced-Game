do
SMODS.Joker:take_ownership('golden', 
 {
    cost = 4,
    config = { extra = { dollars = 3} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calc_dollar_bonus = function (self, card)
        return card.ability.extra.dollars
    end

 }, true)

 SMODS.Joker:take_ownership('sly', 
 {
    cost = 4,
    config = { extra = { chips = 30, type = 'Pair' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function (self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips
            }
        end
    end

 }, true)

 SMODS.Joker:take_ownership('ice_cream', 
 {
    config = { extra = { chips = 120, chip_mod = 15 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,

    calculate = function (self, card, context)
        if context.after and not context.blueprint then 
            if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_melted_ex'),
                    colour = G.C.CHIPS
                }
            else
                card.ability.extra.chips  = card.ability.extra.chips - card.ability.extra.chip_mod
                return {
                    message = localize{ type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_mod } },
                    colour = G.C.CHIPS
                }
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end

 }, true)


end

SMODS.Joker:take_ownership('steel_joker', 
 {
    name = "BBG_steel_joker",
    rarity = 1,
    config = { extra = { xMult =.25} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel

        local steel_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
            end
        end
        return { vars = { card.ability.extra.xMult, 1 + card.ability.extra.xMult * steel_tally } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            local steel_tally = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
                end
            end
            return {
                xmult = 1 + card.ability.extra.xMult * steel_tally
            }
        end
    end
 }, true)

 SMODS.Joker:take_ownership('half', 
 {
    name = "BBG_half",
    config = { extra = {mult = 15, size = 3 } },
    pixel_size = { h = 95 / 1.7 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand <= card.ability.extra.size then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }, true)

 SMODS.Joker:take_ownership('mystic_summit', 
 {
    name = "BBG_mystic_summit",
    config = { extra = {mult = 12, d_remaining = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.d_remaining } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.discards_left <=card.ability.extra.d_remaining  then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }, true)

 SMODS.Joker:take_ownership('superposition', {
    name = "BBG_superposition",
    config = {extra = { consumable = 'c_fool' } },
    loc_vars = function(self, info_queue, back)
        return { vars = {localize { type = 'name_text', key = self.config.extra.consumable, set = 'Tarot'  }} }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Straight"]) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local ace_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                    break
                end
            end
            if ace_check then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card({key = card.ability.extra.consumable})
                        
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        end
    end
 }, true)

 SMODS.Joker:take_ownership('hiker', {
    rarity = 1,
    config = { extra = { chips = 6 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                card.ability.extra.chips
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
    end
}, true)


SMODS.Joker:take_ownership('throwback', {
    name ='BBG_throwback',
    config = { extra = { xmult = 0.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, 1 + G.GAME.skips * card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + G.GAME.skips * card.ability.extra.xmult } }
            }
        end
        if context.joker_main then
            return {
                xmult = 1 + G.GAME.skips * card.ability.extra.xmult
            }
        end
    end,

}, true )

SMODS.Joker:take_ownership('hologram', {
    config = { extra = { Xmult_gain = 0.2, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.playing_card_added and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + #context.cards * card.ability.extra.Xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
            }
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
}, true)

SMODS.Joker:take_ownership('trading',{
    config = { extra = { dollars = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            return {
                dollars = card.ability.extra.dollars,
                remove = true,
                delay = 0.45
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('campfire',{
    config = { extra = { xmult_gain = 0.2, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)

        if context.selling_card and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize('k_upgrade_ex'),
            }
        end
         if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if context.beat_boss and card.ability.extra.xmult > 1 then
                card.ability.extra.xmult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

    end
}, true)

SMODS.Joker:take_ownership('to_the_moon', {
    name = "BBG_to_the_moon",
    config = { extra = { dollars = 1, dollars_rate = 5, interest_cap = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollars_rate, card.ability.extra.interest_cap } }
    end,

    calc_dollar_bonus = function(self, card)
        return G.GAME.dollars >= card.ability.extra.dollars_rate and math.min(card.ability.extra.dollars *
         math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars_rate), card.ability.extra.interest_cap)
        
    end

}, true)

SMODS.Joker:take_ownership('swashbuckler',
 {
    cost = 5,
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local sell_cost = 0
        for _, area in ipairs({ G.jokers, G.consumeables }) do
            for _, other_card in ipairs(area.cards) do
                if other_card ~= card then
                    sell_cost = sell_cost + other_card.sell_cost
                end
            end
        end
        return { vars = { card.ability.extra.mult * sell_cost} }
    end,
    calculate = function(self, card, context)

        if context.joker_main then
            local sell_cost = 0
            for _, area in ipairs({ G.jokers, G.consumeables }) do
                for _, other_card in ipairs(area.cards) do
                    if other_card ~= card then
                        sell_cost = sell_cost + other_card.sell_cost
                    end
                end
            end
            return {
                mult = card.ability.extra.mult * sell_cost
            }
        end
    end,

}, true)

SMODS.Joker:take_ownership('business',
{
    name = "BBG_business",
    cost = 6,
    config = { extra = { dollars = 1 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'BBG_business')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_face() then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, this goes after the dollar modification
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('blue_joker',
{
    name = "BBG_blue_joker",
    config = { extra = { chips = 100 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips} }
    end,
    calculate = function(self, card, context)
        if context.joker_main  and G.GAME.current_round.hands_played == 0 then
            return {
                chips = card.ability.extra.chips
            }
        end 
    end
}, true)

SMODS.Joker:take_ownership('space',
{
    name = "BBG_space",
    config = { extra = { odds = 3} },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'BBG_space')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'BBG_space', 1, card.ability.extra.odds) then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end
}, true)


