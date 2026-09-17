SMODS.Joker:take_ownership('midas_mask', {
    name = "BBG_midas_mask",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 3,
    cost = 8,
    config= {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return {key = "j_midas_mask_BBG"}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                scored_card:set_ability('m_gold', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
            end
            return {
                message = localize('k_gold'),
                colour = G.C.MONEY
            }
        end
    end,
    generate_ui = SMODS.Joker.generate_ui,
    can_sell = function (self, card)
        return false
    end
    
}, true)