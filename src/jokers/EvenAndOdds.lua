SMODS.Joker:take_ownership('even_steven',
{
    name = "BBG_even_steven",
    config = { extra = { mult = 6, are_evens_even = false} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        local function isCardEven(card)
            local id = card:get_id()
            return id <= 10 and id >= 0 and id % 2 == 0
        end

        if context.before then
            local number_of_even_cards = 0
            for _, playing_card in ipairs(context.scoring_hand) do
                if isCardEven(playing_card) then
                    number_of_even_cards = number_of_even_cards + 1
                end
            end
            card.ability.extra.are_evens_even = number_of_even_cards % 2 == 0
        end

        if context.individual and context.cardarea == G.play and card.ability.extra.are_evens_even  then
            if isCardEven(context.other_card) then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}, true)

SMODS.Joker:take_ownership('odd_todd',
{
    name = "BBG_odd_todd",
    config = { extra = { chips = 37, are_odds_odd = false} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        local function isCardOdd(card)
            local id = card:get_id()
            return id <= 10 and id >= 0 and id % 2 == 1
        end

        if context.before then
            local number_of_odd_cards = 0
            for _, playing_card in ipairs(context.scoring_hand) do
                if isCardOdd(playing_card) then
                    number_of_odd_cards = number_of_odd_cards + 1
                end
            end
            card.ability.extra.are_odds_odd = number_of_odd_cards % 2 == 1
        end

        if context.individual and context.cardarea == G.play and card.ability.extra.are_odds_odd  then
            if isCardOdd(context.other_card) then
                return {
                    chips  = card.ability.extra.chips
                }
            end
        end
    end
}, true)