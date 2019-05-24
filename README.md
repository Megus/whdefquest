# whDefQuest

A little helper library for quest games created with Defold game engine. The basic functions it gives are:

- Inventory management
- Dialogues with NPC

The library itself doesn't use any Defold-specific API, so you can use it with any other game engine.

## How to use

Import ```engine.lua``` and initialize the engine:

```lua
engine.init(level, delegate)
```

```level``` is the level table. It encapsulates the level logic and can expose some functions: ```init()```, ```final()```, ```on_pick_item(engine, item)```, ```on_act_npc(engine, npc)```. All these functions are optional, the engine will check if they exist in the level table. More details on these functions later.

```delegate``` is the engine delegate. Your game should react to engine events and delegate. Delegate can implement the following functions: ```on_pick_item(item)```, ```on_inventory_full()```, ```on_update_inventory(items)```, ```show_dialogue(dialogue)```, ```show_choice(options)```. More details in the following sections

### Level table


### Engine delegate


