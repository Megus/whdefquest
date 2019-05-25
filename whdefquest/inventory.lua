local M = {
    module_name = 'inventory'
}

local e

function M.init(defquest)
    e = defquest
    M.items = {}
    M.max_items = nil
end

function M.final()
    e = nil
    M.items = nil
end

function M.pick_item(item)
    -- Check if inventory is full
    if M.max_items ~= null and #(M.items) == M.max_items then
        if e.delegate.on_inventory_full then e.delegate.on_inventory_full() end
        return
    end

    table.insert(M.items, item)

    if e.delegate.on_pick_item ~= nil then e.delegate.on_pick_item(item) end
    if e.level.on_pick_item ~= nil then e.level.on_pick_item(M, item) end
    if e.delegate.on_update_inventory ~= nil then e.delegate.on_update_inventory(M.items) end
end

function M.remove_item(item)
    local idx = nil
    for i, v in ipairs(M.items) do
        if v == item then 
            idx = i
            break
        end
    end
    if idx ~= nil then
        table.remove(M.items, idx)
        if e.delegate.on_update_inventory ~= nil then e.delegate.on_update_inventory(M.items) end
    end
end

function M.has_item(item)
    for i, v in ipairs(M.items) do
        if v == item then return true end
    end
    return false
end

return M