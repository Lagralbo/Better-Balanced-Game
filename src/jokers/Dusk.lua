SMODS.Joker:take_ownership('dusk', 
 {
    name = "BBG_dusk",
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and G.GAME.current_round.hands_left == 0 then
            local valid_cards = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if not SMODS.has_enhancement(scored_card, 'm_stone') then
                    local cen_pool = {}
                    valid_cards = valid_cards + 1
                    for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = enhancement_center.key
                        end
                    end
                    local enhancement = SMODS.poll_enhancement { guaranteed = true, options = cen_pool, key = "BBG_dusk" }

                    scored_card:set_ability(enhancement, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if valid_cards > 0 then
                return {
                    message = localize('k_enhance'),
                    colour = G.C.MONEY
                }
            end
        end 
    end
}, true)