return{
    misc={
        dictionary={
            k_enhance="Enhance",
            ph_lose_money ="After defeating this blind, set money to $0",
            ph_blue_stake_effect ="(Blue Stake Effect)",
        }
    },

    descriptions = {
        Stake = {
            stake_blue = {
                name = "Blue Stake",
                text = {
                    "Every 5 {C:attention}Boss Blind{} deafeated",
                    "set money to {C:money}$0{}",
                    "{s:0.8}Applies all previous Stakes",
                },
            },
        },
        Back = {
            b_black = {
                name = "Black Deck",
                text = {
                    "{C:attention}+#1#{} Joker slot",
                    "",
                    "{C:blue}#2#{} hand",
                    "every round",
                    "Start run with a",
                    "{C:attention}#3#{} card"
                },
            }
        },
        Enhanced = {
            m_mult = {
                name = "Mult Card",
                text = {
                    "{C:mult}+#1#{} Mult",
                },
            },
            m_wild = {
                name = "Wild Card",
                text = {
                    "{C:attention}+#1#{} hand size",
                    "while in hand",
                },
            }
        },
        Tag = {
            tag_coupon = {
                name = "Coupon Tag",
                text = {
                    "In the next shop",
                    "cards and vouchers",
                    "are free and gain",
                    "{C:attention}+2{} card slots",
                },
            },
            tag_ethereal = {
                name = "Ethereal Tag",
                text = {
                    "Gives a free",
                    "{C:spectral}Jumbo Spectral Pack",
                },
            },

            tag_garbage={
                name="Garbage Tag",
                text={
                    "{C:red}+#1#{} discards",
                    "next Boss Blind",
                },
            },

            tag_juggle={
                name="Juggle Tag",
                text={
                    "{C:attention}+#1#{} hand size",
                    "next Boss Blind",
                },
            },
            tag_voucher={
                name="Voucher Tag",
                text={
                    "Adds one {C:attention}Voucher{}",
                    "to the next shop",
                },
            },

            tag_rare={
                name="Rare Tag",
                text={
                    "Shop has a free",
                    "{C:red}Rare Joker",
                    "{C:inactive}#1#",
                },
            },
            tag_uncommon={
                name="Uncommon Tag",
                text={
                    "Shop has a free",
                    "{C:green}Uncommon Joker",
                    "{C:inactive}#1#",
                },
            },

        },
        Other = {
            blue_seal = {
                name = "Blue Seal",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "create the {C:planet}Planet{} card",
                    "for played {C:attention}5{} card poker",
                    "hand if {C:attention}held{} in hand",
                    "{C:inactive}(Must have room)",
                },
            },
        },
        Joker = {
            j_hanging_chad = {
                    name = "Hanging Chad",
                    text = {
                        "Retrigger {C:attention}third{} played",
                        "card used in scoring",
                        "{C:attention}#1#{} additional times",
                    },
                    unlock = {
                        "Beat a Boss Blind",
                        "with a {E:1,C:attention}#1#",
                    },
            },
            j_abstract = {
                name = "Abstract Joker",
                text = {
                    "{C:mult}+#1#{} Mult for",
                    "every other owned {C:attention}Joker{}",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
                }
            },

            j_even_steven = {
                name = "Even Steven",
                text = {
                    "Played cards with",
                    "{C:attention}even{} rank give",
                    "{C:mult}+#1#{} Mult when scored",
                    "if poker hand contains an",
                    "{C:attention} even{} number of them",
                    "{C:inactive}(10, 8, 6, 4, 2)",
                },
            },
            j_odd_todd = {
                name = "Odd Todd",
                text = {
                    "Played cards with",
                    "{C:attention}odd{} rank give",
                    "{C:chips}+#1#{} Chips when scored",
                    "if poker hand contains an",
                    "{C:attention} odd{} number of them",
                    "{C:inactive}(9, 7, 5, 3, 1)",
                },
            },
            j_superposition = {
                name = "Superposition",
                text = {
                    "Create a copy of the {C:tarot,T:c_fool}#1#{}",
                    "if poker hand contains an",
                    "{C:attention}Ace{} and a {C:attention}Straight{}",
                    "{C:inactive}(Must have room)",
                },
            },

            
            j_green_joker = {
                name = "Green Joker",
                text = {
                    "{C:mult}+#1#{} Mult per remaining hand",
                     "at the end of each Round",
                    "{C:mult}-#2#{} Mult per discard",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },

            j_fortune_teller = {
                name = "Fortune Teller",
                text = {
                    "This Joker gains",
                    "{C:red}+#1#{} Mult every time",
                    "a {C:purple}Tarot{} card is used",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive})",
                },
            },

            j_card_sharp = {
                name = "Card Sharp",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "{C:attention}poker hand{} is different",
                    "from the previous one",
                    "{C:inactive}(Last hand: {C:attention}#2#{C:inactive})",
                },
            },
            j_constellation = {
                name = "Constellation",
                text = {
                    "{X:mult,C:white} X#1# {} Mult for each",
                    "unique {C:planet}Planet card",
                    "used this run",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_satellite = {
                name = "Satellite",
                text = {
                    "Add {C:money}$#1#{} of {C:attention}sell value",
                    "to {C:planet}Planet{} cards in your",
                    "{C:attention}consumable{} area",
                    "when {C:attention}Blind{} is selected",
                },
            },

            j_to_the_moon = {
                name = "To the Moon",
                text = {
                    "earn {C:money}$#1#{} for every",
                    "{C:money}$#2#{} you have at",
                    "end of round",
                    "{C:inactive}({C:money}$#3#{C:inactive} Max)",
                },
            },
            j_swashbuckler = {
                name = "Swashbuckler",
                text = {
                    "Adds the sell value of",
                    "all other owned {C:attention}Jokers{}",
                    "and {C:attention}Consumable{} card to Mult",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                },
            },
            j_stone = {
                name = "Stone Joker",
                text = {
                    "Played {C:attention}Stone{} cards",
                    "give {C:chips}+#1#{} Chips",
                    "when scored",
                },
            },

             j_seeing_double = {
                name = "Seeing Double",
                text = {
                    "Retrigger all played",
                    "{C:attention}non{} {C:clubs}Club{} cards{}",
                    "if played hand has a",
                    "scoring {C:clubs}Club{} card",
                },
            },
            j_flower_pot = {
                name = "Flower Pot",
                text = {
                    "First played card of each",
                    "{C:attention}suit{} gives {X:mult,C:white} X#1# {} Mult",
                    "when scored",
                },
            },
            j_business = {
                name = "Business Card",
                text = {
                    "Played {C:attention}face{} cards",
                    "earn {C:money}$#1#{}",
                    "when scored",
                },
            },
            j_rough_gem = {
                name = "Rough Gem",
                text = {                    
                    "{C:green}#1# in #2#{} chance for",
                    "played cards with",
                    "{C:diamonds}Diamond{} suit to earn",
                    "{C:money}$#3#{} when scored",
                },
            },
            j_ancient = {
                name = "Ancient Joker",
                text = {
                    "Each played card with",
                    "{V:1}#2#{} suit gives",
                    "{X:mult,C:white} X#1# {} Mult when scored,",
                    "{s:0.8}suit changes at end of round",
                    "{C:inactive}(next suit: {V:2}#3#{C:inactive})",
                },
            },
            j_scholar = {
                name = "Scholar",
                text = {
                    "{C:mult}+#1#{} Mult for each",
                    "{C:attention}Ace{} scored",
                    "this run",
                     "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_blue_joker = {
                name = "Blue Joker",
                text = {
                    "{C:chips}+#1#{} Chips on {C:attention}first",
                    "{C:attention}hand{} of round",
                },
            },
            j_matador = {
                name = "Matador",
                text = {
                    "Earn {C:money}$#1#{} if played",
                    "hand has only {C:attention}#2#{} card",
                    "while in a {C:attention}Boss Blind{}",
                },
            },
            j_credit_card = {
                name = "Credit Card",
                text = {
                    "{C:money}+$#1#{}",
                    "{C:red}-$#2#{} when this",
                    "card is {C:attention}sold{}",
                },
            },
            j_erosion = {
                name = "Erosion",
                text = {
                    "When round begins,",
                    "destroy a random {C:attention}playing",
                    "{C:attention}card{} and gain {C:mult}Mult{} equal",
                    "to {C:attention}half{} its chip value",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)",
                },
            },
            j_loyalty_card = {
                name = "Loyalty Card",
                text = {
                    "create a free",
                    "{C:attention}#1#{} and",
                    "{C:attention}#2#{} every {C:attention}#3#{}",
                    "Booster Packs opened",
                    "{C:inactive}#4#",
                },
            },
            j_midas_mask_BBG = {
                name = "Midas Mask",

                text = {
                    {
                        "All played {C:attention}cards{}",
                        "become {C:attention}Gold{} cards",
                        "when scored",
                    },
                    {
                        "Can't be {C:attention}sold{}"
                    }
                }
            },
            j_bootstraps = {
                name = "Bootstraps",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "decrease {C:attention}level{} of",
                    "played poker hand",
                },
            },
            j_dusk={
                name="Dusk",
                text={
                    "{C:attention}Enhance{} all played",
                    "cards in {C:attention}final",
                    "{C:attention}hand{} of round",
                },
            },







        }
    }
}