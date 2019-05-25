local M = {}

-- В этой таблице задаются спрайты для каждого предмета. Это нужно для показа инвентаря,
-- так как Defold не позволяет узнать спрайт
-- Ключи: хэши URI GO с предметами
-- Значения: названия спрайтов из sprites.atlas
M.itemSprites = {
    [hash("/Item1")] = "obj1",
    [hash("/Item2")] = "obj2",
}

-- Пример корутины диалога с NPC
local function npc1_1(defquest)
    return coroutine.create(function()
        -- Вот так мы показываем диалог. Структура таблицы простая:
        -- Каждый элемент списка — массив из двух элементов: говорящий, фраза
        defquest.show_dialogue({
            {"Me", "Hello!"},
            {"Bob", "Hello!"},
        })
        -- Вот так мы предлагаем выбор из нескольких вариантов
        local options = {
            "What to answer?",    -- Сначала заголовок окна выбора
            "1",                -- А теперь варианты ответа
            "2",
        }
        if defquest.inventory.has_item(hash("/Item1")) then
            table.insert(options, "Give him Item1")
        end

        local answer = defquest.show_choice(options)

        -- Ответ — число от 1. Т.е. тут на "Fuck off you too!" будет 1.

        if answer == 1 then
            defquest.show_dialogue({
                {"Bob", "1"},
                {"Me", "2"},
            })
        elseif answer == 2 then
            defquest.show_dialogue({
                {"Bob", "1"},
                {"Me", "2"},
            })
        elseif answer == 3 then
            defquest.inventory.remove_item(hash("/Item1"))
            defquest.show_dialogue({
                {"Bob", "What a good Item1!"},
                {"Me", "1"},
            })
        end

        -- Обязательно вызываем finishAct в конце
        defquest.finish_act()
    end)
end



-- Вызывается, когда игрок подбирает предмет. Тут можно что-то делать, если факт подбора
-- предмета на что-то влияет. Если ни на что не влияет, эту функцию можно просто убрать,
-- движок проверяет ее наличие и вызывает только в случае, если она есть.
function M.on_pick_item(defquest, item)

end

-- Функция должна вернуть корутину, которая будет вести диалог с NPC
function M.on_act_npc(defquest, npc)
    if npc == hash("/npc1") then
        return npc1_1(defquest)
    end
end

return M