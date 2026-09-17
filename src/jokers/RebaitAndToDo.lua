 SMODS.Joker:take_ownership('mail',
 {
    name = "BBG_Mail",
    cost = 6,
    config = { extra = { dollars = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, localize((G.GAME.current_round.bbg_mail_card or {}).rank or 'Ace', 'ranks') } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and
            context.other_card:get_id() == G.GAME.current_round.bbg_mail_card.id then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
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

function Reset_bbg_mail_rank() -- Called in GameGlobals.lua to reset the mail card rank at the start of each round
    G.GAME.current_round.bbg_mail_card = { rank = 'Ace' }
    local valid_mail_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_mail_cards[#valid_mail_cards + 1] = playing_card
        end
    end
    local mail_card = pseudorandom_element(valid_mail_cards, 'mail' .. G.GAME.round_resets.ante)
    if mail_card then
        G.GAME.current_round.bbg_mail_card.rank = mail_card.base.value
        G.GAME.current_round.bbg_mail_card.id = mail_card.base.id
    end
end


SMODS.Joker:take_ownership('todo_list', {
    name = "BBG_todo_list",
    config = { extra = { dollars = 5, poker_hand = 'High Card' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'bbg_to_do')
            return {
                message = localize('k_reset')
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'vremade_to_do')
    end
}, true)




