SMODS.Tag:take_ownership('voucher', 
{
    apply = function(self, tag, context)
        if context.type == 'voucher_add' then
            tag:yep('+', G.C.SECONDARY_SET.Voucher, function()
                local voucher = SMODS.add_voucher_to_shop(nil, true)
                voucher.from_tag = true
                return true
            end)
            tag.triggered = true
        end
    end
}, true)



SMODS.Tag:take_ownership('coupon', 
{
    config = { overstock = 2 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.overstock } }
    end,
    apply = function(self, tag, context)
        if context.type == 'shop_final_pass' and G.shop and not G.GAME.shop_free then
            G.GAME.shop_free = true
            G.GAME.shop.coupon_tag = true
            change_shop_size(tag.config.overstock)
            G.GAME.shop.temp_size_mod = tag.config.overstock
            tag:yep('+', G.C.GREEN, function()
                if G.shop_jokers then
                    for _, card in pairs(G.shop_jokers.cards) do
                        card.ability.couponed = true
                        card:set_cost()
                    end

                    
                    -- for _, booster in pairs(G.shop_booster.cards) do
                    --     booster.ability.couponed = true
                    --     booster:set_cost()
                    -- end
                    for _, voucher in pairs(G.shop_vouchers.cards) do
                        voucher.ability.couponed = true
                        voucher:set_cost()
                    end
                end
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}, true)

SMODS.Tag:take_ownership('ethereal', {
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_spectral_jumbo_1
    end,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                local booster = SMODS.create_card { key = 'p_spectral_jumbo_1', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}, true)

SMODS.Tag:take_ownership('juggle', {
    config = { h_size = 4 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.h_size } }
    end,
    apply = function(self, tag, context)
        if context.type == 'round_start_bonus' and G.GAME.blind.boss then
            tag:yep('+', G.C.BLUE, function()
                return true
            end)
            G.hand:change_size(tag.config.h_size)
            G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + tag.config.h_size
            tag.triggered = true
            return true
        end
    end
}, true)

SMODS.Tag:take_ownership('garbage', {
    config = { discards = 3 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.discards } }
    end,
    apply = function(self, tag, context)
        if context.type == 'round_start_bonus' and G.GAME.blind.boss then
            tag:yep('+', G.C.BLUE, function()
                return true
            end)
            ease_discard(tag.config.discards)
            tag.triggered = true
            return true
        end
    end
}, true)


SMODS.Tag:take_ownership('skip', {
    config = { skip_bonus = 8 },
    min_ante = 2,
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.skip_bonus, tag.config.skip_bonus * ((G.GAME.skips or 0) + 1) } }
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.skips or 0) * tag.config.skip_bonus)
            tag.triggered = true
            return true
        end
    end
}, true)


