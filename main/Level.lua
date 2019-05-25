local M = {}

-- I use this table to get animation from game object hash
M.item_sprites = {
    [hash("/item1")] = "obj1",
    [hash("/item2")] = "obj2",
}


-- A sample NPC interaction coroutine
local function npc1_1(defquest)
    return coroutine.create(function()
        -- Show the dialogue using whDefQuest function
        defquest.show_dialogue({
            {"Me", "Hello!"},
            {"Bob", "Hello!"},
        })
        -- And now show the choice
        local options = {
            "What to answer?",    -- Choice prompt
            "A good day today, isn't it?", -- Answer variants
            "Do you need something?",
        }
        -- If we have a specific item, add another option
        if defquest.inventory.has_item(hash("/item1")) then
            table.insert(options, "Give him a ring")
        end

        local answer = defquest.show_choice(options)
        -- answer is a number. 1 is "a good day..."

        -- Depending on what we answered, show different dialogues
        if answer == 1 then
            defquest.show_dialogue({
                {"Bob", "Yes, definitely a good one!"},
                {"Me", "Yeah. Bye!"},
            })
        elseif answer == 2 then
            defquest.show_dialogue({
                {"Bob", "Yes, I lost my ring"},
                {"Me", "Okay, I'll try to find it"},
            })
        elseif answer == 3 then
            defquest.inventory.remove_item(hash("/item1"))
            defquest.show_dialogue({
                {"Bob", "Thank you for bringing my ring back!"},
                {"Me", "You're welcome!"},
            })
        end

        -- We must call finish_act() in the end
        defquest.finish_act()
    end)
end


-- whDefQuest calls this function when a player picks an item. We can do something
-- here, but it's not required. You can even not implement this function.
function M.on_pick_item(defquest, item)

end

-- This function should return a coroutine for interacting with an NPC
function M.on_act_npc(defquest, npc)
    if npc == hash("/npc1") then
        return npc1_1(defquest)
    end
end

return M