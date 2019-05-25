# whDefQuest

A little helper library for quest games created with Defold game defquest. The basic functions it gives are:

- Inventory management
- Dialogues with NPC

The library itself doesn't use any Defold-specific API, so you can use it with any other game engine.

## Table of contents

- [How to use](#how-to-use)
- [whDefQuest functions](#whdefquest-functions)
  - [```defquest.init(level, delegate)```](#defquestinitlevel-delegate)
  - [```defquest.final()```](#defquestfinal)
  - [```defquest.add_module(module)```](#defquestadd_modulemodule)
  - [```defquest.act_npc(npc)```](#defquestact_npcnpc)
- [NPC interaction helper functions](#npc-interaction-helper-functions)
  - [```defquest.show_dialogue(dialogue)```](#defquestshow_dialoguedialogue)
  - [```defquest.show_choice(options)```](#defquestshow_choiceoptions)
  - [```defquest.finish_act()```](#defquestfinish_act)
  - [```defquest.on_dialogue_done()```](#defqueston_dialogue_done)
  - [```defquest.on_choice_selected(choice)```](#defqueston_choice_selectedchoice)
- [Inventory module functions](#inventory-module-functions)
  - [```defquest.inventory.pick_item(item)```](#defquestinventorypick_itemitem)
  - [```defquest.inventory.remove_item(item)```](#defquestinventoryremove_itemitem)
  - [```defquest.inventory.has_item(item)```](#defquestinventoryhas_itemitem)
- [Level table](#level-table)
  - [```init()```](#init)
  - [```final()```](#final)
  - [```on_pick_item(defquest, item)```](#on_pick_itemdefquest-item)
  - [```on_act_npc(defquest, npc)```](#on_act_npcdefquest-npc)
- [whDefQuest delegate](#whdefquest-delegate)
  - [```on_pick_item(item)```](#on_pick_itemitem)
  - [```on_update_inventory(items)```](#on_update_inventoryitems)
  - [```on_inventory_full()```](#on_inventory_full)
  - [```on_finish_act()```](#on_finish_act)
  - [```show_dialogue(dialogue)```](#show_dialoguedialogue)
  - [```show_choice(options)```](#show_choiceoptions)

----

## How to use

Import ```whdefquest/defquest.lua``` and initialize the library:

```lua
defquest.init(level, delegate)
```

```level``` is the level table. It encapsulates the level logic and can expose some functions: ```init()```, ```final()```, ```on_pick_item(defquest, item)```, ```on_act_npc(defquest, npc)```. All these functions are optional, the library will check if they exist in the level table. More details on these functions later.

```delegate``` is the library delegate. Your game should react to events. The delegate can implement the following functions: ```on_pick_item(item)```, ```on_inventory_full()```, ```on_update_inventory(items)```, ```show_dialogue(dialogue)```, ```show_choice(options)```. More details in the following sections.

After initialization you can call other whDefQuest functions, see the documentation below.

----

## whDefQuest functions

#### ```defquest.init(level, delegate)```

Initializes the library with the level and delegate tables. It also registers all built-in modules (currently it's the inventory module).

You can access level and delegate later by referencing ```defquest.level``` and ```defquest.delegate```.

#### ```defquest.final()```

Call this when you're done with the level. This functions frees up all resources and unregisters all modules.

#### ```defquest.add_module(module)```

whDefQuest is modular and you can add your own modules for custom functionality (for example, fighting system). Module is a table and it must have the following fields:

- ```module_name``` – module name string, you will access registered module later by ```defquest.your_module_name.some_function()```
- ```init(defquest)``` – initialize a module
- ```final()``` – finalize a module and free up resources

#### ```defquest.act_npc(npc)```

Interact with an NPC. ```npc``` is an NPC identifier. It can be of any type: a string, a Defold hash. Use anything that works best for you to identify NPCs.

This function will call level's ```on_act_npc``` function, which should return an interaction coroutine. More details on interaction coroutines in the next section and in ```on_act_npc``` function description.

## NPC interaction helper functions

#### ```defquest.show_dialogue(dialogue)```

When you need to show a dialogue during an interaction with an NPC, you call this function and pass a dialogue table. Dialogue table format is up to you, because whDefQuest doesn't provide any predefined GUI implementation. The demo project uses the following format:

```lua
{
    --{"Speaker", "Phrase"}
    {"Alice", "Hi, Bob!"},
    {"Bob", "Hi, Alice!"},
}
```

This function will call corresponding delegate function. When GUI is done with showing a dialogue, you should call ```defquest.on_dialogue_done()``` function. It will resume the interaction coroutine.

#### ```defquest.show_choice(options)```

When you need to ask user to pick one of the options in the middle of an interaction, you call this function and pass an options table. Again, there's no predefined format, you can use anything that works best for you. Demo project uses this format:

```lua
{
    "What to answer?",  -- Prompt
    "Yes",              -- Answer options
    "No",
}
```

This function will call corresponding delegate function. When the answer is selected, you should call ```defquest.on_choice_selected(choice)``` function with the identifier of the selected answer. Again, there's no requirement on data type for the identifier. You can use numbers, strings, or anything else.

#### ```defquest.finish_act()```

When you're done interacting with an NPC in the level code, call this function to clean up the interaction coroutine.

#### ```defquest.on_dialogue_done()```

Call this from GUI when you finish showing a dialogue.

#### ```defquest.on_choice_selected(choice)```

Call this from GUI when user selects an answer.

## Inventory module functions

Inventory is a built-in module of whDefQuest and provides basic inventory management functions. You can limit the maximum number of items in the inventory by settings ```defquest.inventory.max_items``` field. If the inventory should be unlimited, set it to ```nil``` (it's a default value).

#### ```defquest.inventory.pick_item(item)```

Add an item to inventory. ```item``` is the item's identifier. Just like NPC identifier, it can be of any type – string, Defold hash, etc.

This function will call level's ```on_pick_item(item)``` function and delegate's functions:

- ```on_pick_item(item)``` – if the item was successfully picked (good place for the code to remove the picked item from the map)
- ```on_inventory_full()``` – it the inventory is full
- ```on_update_inventory(items)``` – to redraw the inventory

#### ```defquest.inventory.remove_item(item)```

Remove an item from inventory. Does nothing if there's no such item. Will call delegate's ```on_update_inventory(items)``` to redraw the inventory.

#### ```defquest.inventory.has_item(item)```

Checks if there's an ```item``` in the inventory. Use this in your level code.

----

## Level table

You encapsulate level logic in the level table.

#### ```init()```

Initialize a level. This function is optional, whDefQuest checks if it exists.

#### ```final()```

Finalize a level. This function is optional, whDefQuest checks if it exists.

#### ```on_pick_item(defquest, item)```

If you want to react to image picking, implement this function.

#### ```on_act_npc(defquest, npc)```

Should return an interaction coroutine. This coroutine can use whDefQuest functions ```defquest.show_dialogue(dialogue)``` and ```defquest.show_choice(options)```. These functions pause coroutine to show GUI and resumes it when GUI is done. It allows writing interactions in a linear way, without having to deal with callbacks. When the interaction is done, you must call ```defquest.finish_act()```.

----

## whDefQuest delegate

Delegate is the way for whDefQuest to talk to the game engine (Defold or any other engine, actually).

#### ```on_pick_item(item)```

Use this function to remove picked item from the map, for example, or run some animation.

#### ```on_update_inventory(items)```

Use this function to redraw the inventory. ```items``` is the list of item identifiers.

#### ```on_inventory_full()```

If you want to indicate the fact that inventory is full, implement this function.

#### ```on_finish_act()```

Iа you need to show some animation when an interaction with an NPC is done, implement this function.

#### ```show_dialogue(dialogue)```

Show dialogue. Call ```defquest.on_dialogue_done()``` when you finish.

#### ```show_choice(options)```

Show options to select. Call ```defquest.on_choice_selected(choice)``` when user selects an option.
