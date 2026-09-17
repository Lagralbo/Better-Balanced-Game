
function SMODS.current_mod.reset_game_globals(run_start)
    Reset_bbg_mail_rank()    
    Reset_bbg_ancient_card()
    --G.GAME.current_round.misprint_check = false --useful to avoid misprint being resetted multiple times in a round
end

function Create_random_consumable(name, nameLowercase)
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event({
        func = (function()
            SMODS.add_card {
                set = name,
                }
                G.GAME.consumeable_buffer = 0
                return true
            end)
            }))
        return {
            message = localize('k_plus_' .. nameLowercase),
            colour = G.C.SECONDARY_SET[name],
        }
end
SMODS.is_eternal = function (card, trigger)
    local calc_return = {}
    local ovr_compat = false
    local ret = false
    if not trigger then trigger = {} end
    SMODS.calculate_context({check_eternal = true, other_card = card, trigger = trigger, no_blueprint = true,}, calc_return)
    for _,eff in pairs(calc_return) do
        for _,tab in pairs(eff) do
            if tab.no_destroy then --Reuses key from context.joker_type_destroyed
                ret = true
                if type(tab.no_destroy) == 'table' then
                    if tab.no_destroy.override_compat then ovr_compat = true end
                end
            end
        end
    end
    if card.config.center.eternal_compat == false and not ovr_compat then ret = false end
    if card.ability.eternal or card.ability.unsoldable_override   then ret = true end
    return ret
end

SMODS.current_mod.calculate = function(self, context)
    --Scolar logic
    if context.individual and context.cardarea == G.play then
        if context.other_card:get_id() == 14 then
            G.GAME.played_aces = (G.GAME.played_aces or 0) + 1
        end
    end
    --Coupon tag logic
    if context.modify_shop_card then
        if G.GAME.shop.coupon_tag then
            context.card:set_cost_couponed()
        end
    end

    if context.ending_shop then
        if  G.GAME.shop.temp_size_mod then
            change_shop_size(-G.GAME.shop.temp_size_mod)
            G.GAME.shop.temp_size_mod = 0
        end
        G.GAME.shop.coupon_tag = false
    end

    --Blue stakes logic
    local every =5 
    if context.end_of_round and context.game_over == false and context.main_eval then
        if context.beat_boss then
            G.GAME.beaten_bosses_number = (G.GAME.beaten_bosses_number or 0) +1
            if G.GAME.beaten_bosses_number % every == 0 and G.GAME.modifiers.lose_money_5_boss then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    delay = 0.2,
                    func = function()
                     play_sound('tarot2', 0.76, 0.4)
                    ease_dollars(-G.GAME.dollars)
                    return true
                end  }))

            end
        end
    end

    if context.first_hand_drawn and G.GAME.blind.boss then
        if ((G.GAME.beaten_bosses_number or 0) +1) % every == 0 then 
            G.blue_stake_warning_text = UIBox{
                    definition = 
                      {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
                        {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                            {n=G.UIT.O, config={object = DynaText({scale = 0.7, string = localize('ph_lose_money'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
                        }},
                        {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                            {n=G.UIT.O, config={object = DynaText({scale = 0.4, string = localize('ph_blue_stake_effect'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
                        }},
                    }}, 
                    config = {
                        align = 'cm',
                        offset ={x=0,y=-3.1}, 
                        major = G.play,
                      }
                }
        end 
    end

    if (context.before or context.end_of_round or context.pre_discard or G.boss_warning_text) and G.blue_stake_warning_text then
        G.blue_stake_warning_text:remove()
        G.blue_stake_warning_text = nil
    end
end

function Card:set_cost_couponed()
    self.extra_cost = 0 + G.GAME.inflation

    self:set_cost_value()
    self:set_sell_value()

    self.cost = 0 
    self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
end
