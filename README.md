# whDefQuest

A little helper library for quest games created with Defold game engine. The basic functions it gives are:

- Inventory management
- Dialogues with NPC

The library itself doesn't use any Defold-specific API, so you can use it with any other game engine.

## Table of contents

- [How to use](#how-to-use)
- [Engine functions](#engine-functions)
  - [```engine.init(level, delegate)```](#engineinitlevel-delegate)
  - [```engine.final()```](#enginefinal)
  - [```engine.add_module(module)```](engineadd_modulemodule)
  - [```engine.act_npc(npc)```](#engineact_npcnpc)
- [NPC interaction helper functions](#npc-interaction-helper-functions)
  - [```engine.show_dialogue(dialogue)```](#engineshow_dialoguedialogue)
  - [```engine.show_choice(options)```](#engineshow_choiceoptions)
  - [```engine.finish_act()```](#enginefinish_act)
  - [```engine.on_dialogue_done()```](#engineon_dialogue_done)
  - [```engine.on_choice_selected(choice)```](#engineon_choice_selectedchoice)
- [Inventory module functions](#inventory-module-functions)
  - [```engine.inventory.pick_item(item)```](#engineinventorypick_itemitem)
  - [```engine.inventory.remove_item(item)```](#engineinventoryremove_itemitem)
  - [```engine.inventory.has_item(item)```](#engineinventoryhas_itemitem)
- [Level table](#level-table)
  - [```init()```](#init)
  - [```final()```](#final)
  - [```on_pick_item(engine, item)```](#on_pick_itemengine-item)
  - [```on_act_npc(engine, npc)```](#on_act_npcengine-npc)
- [Engine delegate](#engine-delegate)
  - [```on_pick_item(item)```](#on_pick_itemitem)
  - [```on_update_inventory(items)```](#on_update_inventoryitems)
  - [```on_inventory_full()```](#on_inventory_full)
  - [```on_finish_act()```](#on_finish_act)
  - [```show_dialogue(dialogue)```](#show_dialoguedialogue)
  - [```show_choice(options)```](#show_choiceoptions)

----

## How to use

Import ```wh_quest/engine.lua``` and initialize the engine:

```lua
engine.init(level, delegate)
```

```level``` is the level table. It encapsulates the level logic and can expose some functions: ```init()```, ```final()```, ```on_pick_item(engine, item)```, ```on_act_npc(engine, npc)```. All these functions are optional, the engine will check if they exist in the level table. More details on these functions later.

```delegate``` is the engine delegate. Your game should react to engine events and delegate. Delegate can implement the following functions: ```on_pick_item(item)```, ```on_inventory_full()```, ```on_update_inventory(items)```, ```show_dialogue(dialogue)```, ```show_choice(options)```. More details in the following sections.

After initialization you can call other engine functions, see the documentation below.

----

## Engine functions

#### ```engine.init(level, delegate)```

Initializes the engine with the level and delegate tables. It also registers all built-in modules (currently it's inventory module).

You can access level and delegate later by referencing ```engine.level``` and ```engine.delegate```.

#### ```engine.final()```

Call this when you're done with the level. This functions frees up all resources and unregisters all modules.

#### ```engine.add_module(module)```

whDefQuest is modular and you can add your own modules for custom functionality (for example, fighting system). Module is a table and it must have the following fields:

- ```module_name``` – you will access registered module later by ```engine.your_module_name.some_function()```
- ```init(engine)``` – initialize a module
- ```final()``` – finalize a module and free up resources

#### ```engine.act_npc(npc)```

Interact with an NPC. ```npc``` is an NPC identifier. It can be of any type: a string, a Defold hash. Use anything that works best for you to identify NPCs.

This function will call level's ```on_act_npc``` function, which should return an interaction coroutine. More details on interaction coroutines in the next section and in ```on_act_npc``` function description.

## NPC interaction helper functions

#### ```engine.show_dialogue(dialogue)```

When you need to show a dialogue during an interaction with an NPC, you call this function and pass a dialogue table. Dialogue table format is up to you, because whDefQuest doesn't provide any predefined GUI implementation, but the demo project uses the following format:

```lua
{
    --{"Speaker", "Phrase"}
    {"Alice", "Hi, Bob!"},
    {"Bob", "Hi, Alice!"},
}
```

This function will call delegate's corresponding function. When GUI is done with showing a dialogue, you should call ```engine.on_dialogue_done()``` function. It will resume the interaction coroutine.

#### ```engine.show_choice(options)```

When you need to ask user to pick one of the options in the middle of an interaction, you call this function and pass an options table. Again, there's no predefined format, you can use anything that works best for you. Demo project uses this format:

```lua
{
    "What to answer?",  -- Prompt
    "Yes",              -- Answer options
    "No",
}
```

This function will call delegate's corresponding function. When the answer is selected, you should call ```engine.on_choice_selected(choice)``` function with the identifier of the selected answer. Again, there's no requirement on data type for the identifier. You can use numbers, strings, or anything else.

#### ```engine.finish_act()```

When you're done interacting with an NPC in the level code, call this function to clean up the interaction coroutine.

#### ```engine.on_dialogue_done()```

Call this from GUI when you finish showing a dialogue.

#### ```engine.on_choice_selected(choice)```

Call this from GUI when user selects an answer.

## Inventory module functions

Inventory is a built-in module of whDefQuest and provides basic inventory management functions. You can limit the maximum number of items in the inventory by settings ```engine.inventory.max_items``` field. If the inventory should be unlimited, set it to ```nil``` (it's a default value).

#### ```engine.inventory.pick_item(item)```

Add an item to inventory. ```item``` is the item's identifier. Just like NPC identifier, it can be of any type – string, Defold hash, etc.

This function will call level's ```on_pick_item(item)``` function and delegate's functions:

- ```on_pick_item(item)``` – if the item was successfully picked (good place for the code to remove the picked item from the map)
- ```on_inventory_full()``` – it the inventory is full
- ```on_update_inventory(items)``` – to redraw the inventory

#### ```engine.inventory.remove_item(item)```

Remove an item from inventory. Does nothing if there's no such item. Will call delegate's ```on_update_inventory(items)``` to redraw the inventory.

#### ```engine.inventory.has_item(item)```

Checks if there's an ```item``` in the inventory. Use this in your level code.

----

## Level table

#### ```init()```

#### ```final()```

#### ```on_pick_item(engine, item)```

#### ```on_act_npc(engine, npc)```


----

## Engine delegate

#### ```on_pick_item(item)```

#### ```on_update_inventory(items)```

#### ```on_inventory_full()```

#### ```on_finish_act()```

#### ```show_dialogue(dialogue)```

#### ```show_choice(options)```
