
SMODS.Joker:take_ownership('constellation',{
    name = 'BBG_constellation',
    perishable_compat = true,
    config = { extra = { Xmult_mod = 0.25, usedPlanetCards = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_mod, 1 + GetUsedPlanetCards()*card.ability.extra.Xmult_mod } }
    end,
    calculate = function(self, card, context)
         if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Planet' then
            if GetUsedPlanetCards() ~= card.ability.extra.usedPlanetCards  then
                card.ability.extra.usedPlanetCards = GetUsedPlanetCards()
                return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + GetUsedPlanetCards()*card.ability.extra.Xmult_mod } }
                }
            end
        end
            

        if context.joker_main then
            return {
                Xmult = 1 + GetUsedPlanetCards()*card.ability.extra.Xmult_mod
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.usedPlanetCards = GetUsedPlanetCards()
    end,
}, true)

function GetUsedPlanetCards()
    local planets_used = 0
        for _, consumable_data in pairs(G.GAME.consumeable_usage) do
            if consumable_data.set == 'Planet' then
                planets_used =
                    planets_used + 1
            end
        end
    return planets_used
end

SMODS.Joker:take_ownership('satellite', {
    name = 'BBG_satellite',
    blueprint_compat = false,
    perishable_compat = true,

    config = { extra = { sell_value = 6} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sell_value} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local worked = false
            for _, area in ipairs({G.consumeables }) do
                for _, other_card in ipairs(area.cards) do
                    if other_card.set_cost and other_card.ability.set == 'Planet' then
                        other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                            card.ability.extra.sell_value
                        other_card:set_cost()
                        worked = true
                    end
                end
            end

            if  worked then
                return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
            end

        end

        
    end,
}, true)

