SMODS.Joker:take_ownership('misprint', 
 {
    name = "BBG_misprint",
    eternal_compat = false,
    rarity = 1,
    cost = 4,
    config = { extra = {number_of_effects = 14, current_effect = 0, chips = 1, mult = 5, Xmult = 2,
        dollars = -2, dollars_per_card = 1, chips_per_card = 12, mult_per_card = 2, repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        local numbers = {}
        for i = 0, 9 do
            numbers[#numbers + 1] = '' .. tostring(i)
        end
        local question_mark = ' ' .. '?????' .. ' '
        local loc_tarot = ' ' .. (localize('k_tarot')) .. ' '
        local loc_mult = ' ' .. (localize('k_mult')) .. ' '
        local loc_planet = ' ' .. (localize('k_planet')) .. ' '
        local loc_spectral = ' ' .. (localize('k_spectral')) .. ' '


        local main_start = {
            { n = G.UIT.O, config = {  object = DynaText({ string = {'  +', '  +','  +','  +','  +','  +','  +','  +', '  -', '  -', '  x', '  +', '  -', '  +', '  +','  +','  +'}, 
                colours = { G.C.UI.TEXT_DARK}, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) }  },
            { n = G.UIT.O, config = { object = DynaText({ string = numbers, colours = { G.C.UI.TEXT_DARK}, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                            question_mark, question_mark, question_mark, question_mark, question_mark, question_mark, question_mark, question_mark, question_mark,
                            question_mark, question_mark, question_mark, question_mark, { string = loc_tarot, colour = G.C.PURPLE }, { string = loc_spectral, colour = G.C.SPECTRAL }, { string = loc_planet, colour = G.C.PLANET }, { string = loc_mult, colour = G.C.MULT }},
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }
        return { main_start = main_start }
    end,
    calculate = function(self, card, context)
        local function areConsumableFull ()
            return #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit
        end
        if context.before then
            card.ability.extra.current_effect = pseudorandom('BBG_Misprint', 1, card.ability.extra.number_of_effects)
        end


        if context.before then
            if  card.ability.extra.current_effect  == 13 then 
            return {
                level_up = true,
                message = localize('k_level_up_ex')}
            end 
        end

        if context.joker_main then
            if card.ability.extra.current_effect  == 1 then
                return {chips = card.ability.extra.chips}
            elseif card.ability.extra.current_effect  == 2 then
                return {mult = card.ability.extra.mult}
            elseif card.ability.extra.current_effect  == 3 and not areConsumableFull() then
                return Create_random_consumable('Tarot', 'tarot')
            elseif card.ability.extra.current_effect == 4 and not areConsumableFull() then
                return Create_random_consumable('Spectral', 'spectral')
            elseif card.ability.extra.current_effect  == 5 and not areConsumableFull() then
                return Create_random_consumable('Planet', 'planet')
            elseif card.ability.extra.current_effect  == 6 then
                return { xmult  = card.ability.extra.Xmult}
            elseif card.ability.extra.current_effect  == 7 then
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true end
                        }))
                    end    
                }
            elseif card.ability.extra.current_effect  == 8 and not context.blueprint  then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eroded_ex'),
                    colour = G.C.CHIPS
                }
            elseif card.ability.extra.current_effect  == 9 then
                local _card = SMODS.create_card { set = "Base", area = G.discard, key_append = "BBG_Misprint" }
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                _card.playing_card = G.playing_card
                table.insert(G.playing_cards, _card)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(_card)
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()
                        if context.blueprint_card then
                            context.blueprint_card:juice_up()
                        else
                            card:juice_up()
                        end
                         SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                         save_run()
                    return true
                end
                }))  return nil, true
            end
        end

        if context.individual and context.cardarea == G.play then
            if card.ability.extra.current_effect  == 10 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars_per_card,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true end
                        }))
                    end    
                }
            elseif card.ability.extra.current_effect  == 11 then
                return {mult = card.ability.extra.mult_per_card}
            elseif card.ability.extra.current_effect  == 12 then
                return {chips = card.ability.extra.chips_per_card}
            end
           
        end

        if context.repetitions and context.cardarea == G.play then
            if  card.ability.extra.current_effect  == 14 then 
                return {repetitions  = card.ability.extra.repetitions}
            end
        end
    end
}, true)

--[[
function Reset_misprint_value(maxValue)
    if(not G.GAME.current_round.misprint_check) then
         G.GAME.current_round.misprint_value = pseudorandom('BBG_Misprint', 1, card.ability.extra.number_of_effects)
         G.GAME.current_round.misprint_check = true
    end
end

]]--
