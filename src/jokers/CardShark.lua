SMODS.Joker:take_ownership('card_sharp', {
    name = 'BBG_cards_harp',
    config = { extra = { Xmult = 2, last_hand = 'nil'} },
    loc_vars = function(self, info_queue, card)
        local  function getLastHand()
            if SMODS.last_hand then
                return SMODS.last_hand.scoring_name
            else return 'None' end
        end
        return { vars = { card.ability.extra.Xmult, getLastHand()} }
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint then 
            card.ability.extra.last_hand = SMODS.last_hand.scoring_name
        end

        if context.joker_main and card.ability.extra.last_hand  ~= context.scoring_name then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if SMODS.last_hand then
             card.ability.extra.last_hand = SMODS.last_hand.scoring_name
        end
    end,

}, true)
