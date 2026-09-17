

-- SMODS.Tag {
--     key = "orbital",
--     min_ante = 2,
--     pos = { x = 5, y = 2 },
--     config = { levels = 3 },
--     loc_vars = function(self, info_queue, tag)
--         return {
--             vars = {
--                 (tag.ability.orbital_hand == '[' .. localize('k_poker_hand') .. ']') and tag.ability.orbital_hand or
--                 localize(tag.ability.orbital_hand, 'poker_hands'), tag.config.levels }
--         }
--     end,
--     set_ability = function(self, tag)
--         if G.orbital_hand then
--             tag.ability.orbital_hand = G.orbital_hand
--         elseif tag.ability.blind_type then
--             if G.GAME.orbital_choices and G.GAME.orbital_choices[G.GAME.round_resets.ante][tag.ability.blind_type] then
--                 tag.ability.orbital_hand = G.GAME.orbital_choices[G.GAME.round_resets.ante][tag.ability.blind_type]
--             end
--         end
--     end,
--     apply = function(self, tag, context)
--         if context.type == 'immediate' then
--             local lock = tag.ID
--             G.CONTROLLER.locks[lock] = true
--             SMODS.upgrade_poker_hands({ from = tag, hands = { tag.ability.orbital_hand }, level_up = tag.config.levels })
--             tag:yep('+', G.C.MONEY, function()
--                 G.CONTROLLER.locks[lock] = nil
--                 return true
--             end)
--             tag.triggered = true
--             return true
--         end
--     end
-- }


SMODS.Tag:take_ownership('investment', {
    config = { dollars = 10, dollars_per_ante = 5 },
    loc_vars = function(self, info_queue, tag)
        return {vars = {
                tag.ability.total_dollars or ('[' .. localize('k_money') .. ']')
            }}
    end,
    apply = function(self, tag, context)
        if context.type == 'eval' then
            if G.GAME.last_blind and G.GAME.last_blind.boss then
                tag:yep('+', G.C.GOLD, function()
                    return true
                end)
                tag.triggered = true
                return {
                    dollars = tag.ability.total_dollars,
                    condition = localize('ph_defeat_the_boss'),
                    pos = tag.pos,
                    tag = tag
                }
            end
        end
    end,

    set_ability = function(self, tag)
        if G.GAME.round_resets.ante then
            tag.ability.total_dollars = tag.config.dollars + (tag.config.dollars_per_ante * G.GAME.round_resets.ante)
        end
    end,
}, true)

SMODS.Tag:take_ownership('boss', {
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.GREEN, function()
                G.from_boss_tag = true
                G.FUNCS.reroll_boss()

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.CONTROLLER.locks[lock] = nil
                                return true
                            end
                        }))
                        return true
                    end
                }))

                return true
            end)
            tag.triggered = true
            return true
        end
    end
}, true)
SMODS.Tag:take_ownership('uncommon', {
    loc_vars = function(self, info_queue, tag)
        return {vars = {
               GetTagLocText(tag.ability.joker_card)
            }}
    end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            if  tag.ability.joker_card then
                local card = SMODS.create_card {
                    set = "Joker",
                    key = tag.ability.joker_card,
                    area = context.area,
                    key_append = "bbg_rta"
                }
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                tag.triggered = true
                return card
            else
                tag.ability.joker_card = GenerateUncommon()
                --tag:nope()
            end
        end
    end,
    set_ability = function(self, tag)
        if tag.ability.blind_type then
            tag.ability.joker_card = GenerateUncommon()
        end
    end,
}, true)

-- Rare Tag
SMODS.Tag:take_ownership('rare', {
    loc_vars = function(self, info_queue, tag)
        return {vars = {
                GetTagLocText(tag.ability.joker_card)
            }}
    end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            if  tag.ability.joker_card then
                local card = SMODS.create_card {
                    set = "Joker",
                    key = tag.ability.joker_card,
                    area = context.area,
                    key_append = "bbg_rta"
                }
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                tag.triggered = true
                return card
            else
                tag.ability.joker_card = GenerateRare()
                --tag:nope()
            end
        end
    end,
    set_ability = function(self, tag)
        if tag.ability.blind_type then
            tag.ability.joker_card = GenerateRare()
        end
    end,
}, true)
GetTagLocText = function (key)
    if key then 
        return '(Will give: ' ..localize{ key = key, set = "Joker", type = "name_text" }..')'
    else 
        return '(Random)'
    end
end
GenerateRare = function ()
    local rares_in_posession = { 0 }
    local card
    for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.rarity == 3 and not rares_in_posession[joker.config.center.key] then
                    rares_in_posession[1] = rares_in_posession[1] + 1
                    rares_in_posession[joker.config.center.key] = true
                end
    end
    if #G.P_JOKER_RARITY_POOLS[3] > rares_in_posession[1] then
        card = SMODS.poll_object{
            type = 'Joker',
            guaranteed = true,
            --rarity = "Rare",
            rarities = { "Rare" }
        }
    end 
    return card
end

GenerateUncommon = function ()
    local uncommon_in_posession = { 0 }
    local card
    for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.rarity == 2 and not uncommon_in_posession[joker.config.center.key] then
                    uncommon_in_posession[1] = uncommon_in_posession[1] + 1
                    uncommon_in_posession[joker.config.center.key] = true
                end
    end
    if #G.P_JOKER_RARITY_POOLS[2] > uncommon_in_posession[1] then
        card = SMODS.poll_object{
            type = 'Joker',
            guaranteed = true,
            rarities = { "Uncommon" }
        }
    end 
    return card
end