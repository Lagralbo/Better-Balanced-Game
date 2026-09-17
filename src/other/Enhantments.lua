SMODS.Enhancement:take_ownership('mult', {
    config = { mult = 5},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult } }
    end,
}, true)

SMODS.Enhancement:take_ownership('wild',{

    config = { handsize = 1, card_limit  = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.handsize } }
    end,

    any_suit = false,
}, true)

SMODS.has_any_suit  =  function (card) --Overrides the default method to disable wild
    for k, _ in pairs(SMODS.get_enhancements(card)) do
        if  G.P_CENTERS[k].any_suit then return true end
    end
end

--if k == 'm_wild' or G.P_CENTERS[k].any_suit then return true end            
--G.hand:change_size(tag.config.h_size)
            --G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + tag.config.h_size