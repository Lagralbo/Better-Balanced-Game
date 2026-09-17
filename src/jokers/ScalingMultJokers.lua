SMODS.Joker:take_ownership('scholar', 
 {
    name = "BBG_scholar",
    config = { extra = { mult = 1} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, G.GAME.played_aces or 0 } }
    end,

    calculate = function (self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
        if context.other_card:get_id() == 14 then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                message_card = card
            }
        end
    end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * (G.GAME.played_aces or 0)
            }
        end
    end,

}, true)

SMODS.Joker:take_ownership('fortune_teller',{

    name = 'BBG_fortune_teller',
    cost = 5,
    perishable_compat = false,
    config = { extra = { mult = 0, mult_per_tarot = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_per_tarot, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Tarot' then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_per_tarot
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_per_tarot} }
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('erosion', {
    name = 'BBG_erosion',
    perishable_compat = false,
    config = {extra =  {current_mult = 0, destroy = 1}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_mult, card.ability.extra.destroy} }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
                G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            SMODS.destroy_cards(card_to_destroy)

            --card.ability.extra.current_mult = card.ability.extra.current_mult + card_to_destroy.base.nominal
            card.ability.extra.current_mult = card.ability.extra.current_mult + math.floor (card_to_destroy:get_chip_bonus()/2)
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.current_mult } }
            }
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.current_mult,
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('green_joker', {

    name = 'BBG_green_joker',
    cost = 5,
    config = { extra = { remaining_hand_add = 2, discard_sub = 2, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.remaining_hand_add, card.ability.extra.discard_sub, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
            local prev_mult = card.ability.extra.mult
            card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.discard_sub)
            if card.ability.extra.mult ~= prev_mult then
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.discard_sub } },
                    colour = G.C.RED
                }
            end
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.remaining_hand_add * G.GAME.current_round.hands_left
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.remaining_hand_add * G.GAME.current_round.hands_left } }
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

    end
}, true)