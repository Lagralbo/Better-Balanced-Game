SMODS.Joker:take_ownership('flower_pot', 
 {
    name = "BBG_flower_pot",
    config = { extra = { xMult= 1.3} },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xMult} }
    end,

    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play  then

            local suits = {
                ['Hearts'] = false,
                ['Diamonds'] = false,
                ['Spades'] = false,
                ['Clubs'] = false
            }
            for key, value in pairs(suits) do
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_suit(key) then
                        suits[key] = context.scoring_hand[i] == context.other_card
                        break
                    end
                end
            end

            if suits["Hearts"] or suits["Diamonds"] or suits["Spades"] or suits["Clubs"] then
                return {
                    xmult = card.ability.extra.xMult
                }
            end
        end
        
    end
}, true)

SMODS.Joker:take_ownership('seeing_double', 
 {
    name = "BBG_seeing_double",
    config = { extra = {repetitions = 1} },    
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,

    calculate = function (self, card, context)
         if context.repetition and context.cardarea == G.play then
            local has_clubs = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit('Clubs') then
                    has_clubs = true
                end
            end

            if has_clubs and not context.other_card:is_suit('Clubs') then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
}, true)

SMODS.Joker:take_ownership('rough_gem', 
 {
    name = "BBG_rough_gem",
    config = { extra = { odds = 2, dollars = 3 }},    
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'BBG_rough_gem')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds") 
            and  SMODS.pseudorandom_probability(card, 'BBG_rough_gem', 1, card.ability.extra.odds) then
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
    end,
}, true)

SMODS.Joker:take_ownership('ancient', {
    name = "BBG_ancient",

    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.bbg_ancient_card or {}).suit or 'Spades'
        local next_suit = (G.GAME.current_round.bbg_next_ancient_card or {}).suit or 'Spades'
        return { vars = { card.ability.extra.xmult, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit], G.C.SUITS[next_suit]  }, localize(next_suit, 'suits_singular')} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(G.GAME.current_round.bbg_ancient_card.suit) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
    
}, true)

function Reset_bbg_ancient_card()
    G.GAME.current_round.bbg_ancient_card = G.GAME.current_round.bbg_ancient_card or { suit = 'Spades' }
    G.GAME.current_round.bbg_next_ancient_card = G.GAME.current_round.bbg_next_ancient_card or { suit = 'Spades' }

    G.GAME.current_round.bbg_ancient_card.suit = G.GAME.current_round.bbg_next_ancient_card.suit

    local ancient_suits = {}
    for _, suit_key in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if suit_key ~= G.GAME.current_round.bbg_ancient_card.suit then ancient_suits[#ancient_suits + 1] = suit_key end
    end
    local ancient_card = pseudorandom_element(ancient_suits, 'bbg_ancient' .. G.GAME.round_resets.ante)
    
    G.GAME.current_round.bbg_next_ancient_card.suit = ancient_card
end