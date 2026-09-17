SMODS.Back:take_ownership('black', {
    name = "BBG_Black",
    config = { hands = -1, joker_slot = 1, joker = 'j_joker' },
    unlocked = false,
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot, self.config.hands, localize { type = 'name_text', key = self.config.joker, set = 'Joker' }} }
    end,
    apply = function(self, back)

        delay(0.4)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({key = self.config.joker, no_edition = true})
                return true
            end
        }))
    end,
    locked_loc_vars = function(self, info_queue, back)
        return { vars = { 100 } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'discover_amount' and args.amount >= 100
    end
}, true)