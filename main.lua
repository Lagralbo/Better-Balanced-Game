local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path.."src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/"..file))()
end

local other_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path.."src/other")
for _, file in ipairs(other_src) do
    assert(SMODS.load_file("src/other/"..file))()
end