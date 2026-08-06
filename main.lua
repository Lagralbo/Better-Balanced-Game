local jokers_src = SMODS.NFS.getDirecoryItems(SMODS.current_mod.path.."src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/"..file))()
end