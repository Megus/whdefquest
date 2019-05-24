local inventory = require("wh_quest.inventory")

local M = {}

local current_co = nil
local modules = {}

function M.init(level, delegate)
    M.level = level
    M.delegate = delegate
    if level.init ~= nil then level.init() end
    currentCo = nil
    modules = {}

    M.add_module(inventory)
end

function M.final()
    if M.level.final ~= nil then M.level.final() end
    M.level = nil
    M.delegate = nil
    currentCo = nil

    for name, module in pairs(modules) do
        M[name] = nil
        if module.final ~= nil then module.final() end
    end
    modules = {}
end

function M.add_module(module)
    local name = module.module_name
    assert(name ~= nil, "Module must have a module_name field with the name")
    assert(M[name] == nil, "Module name shouldn't conflict with engine functions")

    M[name] = module
    modules[name] = module
    module.init(M)
end

function M.act_npc(npc)
    assert(current_co == nil, "You can't talk to another NPC if the previous dialogue is not finished")
    current_co = M.level.on_act_npc(M, npc)
    coroutine.resume(current_co)
end



-- Interaction coroutine helpers

function M.show_dialogue(dialogue)
    M.delegate.show_dialogue(dialogue)
    return coroutine.yield()
end

function M.show_choice(options)
    M.delegate.show_choice(options)
    return coroutine.yield()
end

function M.finish_act()
    M.delegate.on_finish_act()
    current_co = nil
end


function M.on_dialogue_done()
    coroutine.resume(current_co)
end

function M.on_choice_selected(choice)
    coroutine.resume(current_co, choice)
end

return M