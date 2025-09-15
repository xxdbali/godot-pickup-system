# godot-pickup-system

# Godot FPS Pickup System with Inventory & Save/Load Manager

This project is a modular FPS-style object pickup system built in **Godot**, enhanced with an **inventory manager** and a **node store** for handling save/load functionality. It's ideal for first-person games that require dynamic interaction with objects, real-time inventory control, and persistent world state.

## 🚀 Features

- **FPS Object Pickup System**

  - Raycast-based interaction
  - Works with physics-based or static scene nodes
  - Custom pickup rules (distance, tags, filters)

- **Inventory System**

  - Add/remove items dynamically
  - Item metadata support (e.g., type, quantity, custom ID)
  - Slot management and visual feedback integration

- **Node Store & State Manager**

  - Saves picked-up object data (position, state, ID)
  - Restores objects from inventory back into the scene
  - Handles loading and saving the entire game state

- **Modular and Extensible**
  - Drop-in ready for new or existing Godot FPS projects
  - Easy to customize item behaviors and inventory logic

## 🧩 Use Cases

- First-person adventure or survival games
- Puzzle games where objects are picked and used later
- Inventory-heavy games needing scene persistence
- Prototypes that evolve into full save/load-capable projects

## 📦 Structure Overview

The system is divided into a few focused components:

### Item Data & Conventions

`types/inventory_item_conventions.gd` centralizes all immutable item type data using:

- `enum ItemID` – canonical identifiers for every item in the game.
- `InventoryItemBase` – a Resource-like base definition (id, name, stackability, category, rarity, icon path, optional scene path).
- `ITEM_SPEC_DATA` – a dictionary mapping every `ItemID` to an `InventoryItemBase` instance.
- Helper functions (`name_for`, `is_stackable`, `max_stack`, etc.) for quick lookups.

### Item Instances

`types/inventory_item.gd` defines `InventoryItem`, which extends `InventoryItemBase` and adds only variable / runtime state:

- `item_id` (unique instance identifier separate from ItemID)
- `qty`, `inventory_slot_index`, `transform`
- Constructor: `InventoryItem.new(base_entity_id, qty := 1, transform := Transform3D(), slot_index := -1)` pulls immutable fields from conventions automatically.

### Object Pickup

`object_picker_node.gd` handles:

- Ray cast interaction (pickup / drop / store / restore)
- Signals: `object_picked_up`, `object_dropped`
- Storing the held object's `InventoryItem` into an `InventoryHub` (expected global singleton / array)
- Restoring last stored item by re-instantiating its scene and reapplying transform + metadata

### UI Layer

- `ui/inventory_item.gd` & related scenes provide a TextureRect-based visual for inventory slots.
- Icons currently default (icon paths are blank placeholder values) – ready to be populated.

### Data Design Philosophy

1. Immutable base specs live in one place (balance-friendly & versionable).
2. Instances only store what can change (qty, location, slot assignment).
3. No redundant duplication: `get_item_spec` returns the base object directly.

## 🗂 Key Scripts

| File                                  | Purpose                                           |
| ------------------------------------- | ------------------------------------------------- |
| `types/inventory_item_base.gd`        | Immutable base item structure.                    |
| `types/inventory_item_conventions.gd` | Enums, base registry, helpers.                    |
| `types/inventory_item.gd`             | Runtime instance (inherits base + mutable state). |
| `object_picker_node.gd`               | Handles pick/drop/store/restore interactions.     |
| `ui/inventory_item.gd`                | UI widget for displaying an item instance.        |

## 🔧 Creating & Using Items

Basic instancing from an ID:

```gdscript
var sword := InventoryItem.new(InventoryItemConventions.ItemID.CRYSTAL_BLADE)
print(sword.name) # "Crystal Blade"
print(sword.qty)  # 1 (non-stackable forced)
```

Stackable items with quantity:

```gdscript
var coins := InventoryItem.new(InventoryItemConventions.ItemID.MYSTIC_COIN, 137)
print(coins.qty) # 137 (capped automatically if desired in future logic)
```

From object pickup flow:

```gdscript
func store_held_object_to_inventory():
  if not held_object:
    return
  InventoryHub.append(held_object.get_inventory_item())
  held_object.queue_free()
```

Restoring:

```gdscript
var item := InventoryHub.pop_back()
var scene := load(item.item_scene_path)
var inst := scene.instantiate()
inst.global_transform = item.transform
get_tree().current_scene.add_child(inst)
```

## 🧪 Signals

| Signal             | Emitted When                 | Payload       |
| ------------------ | ---------------------------- | ------------- |
| `object_picked_up` | Player grabs an object       | Picked node   |
| `object_dropped`   | Player drops / throws object | Released node |

## 🧱 Categories & Rarity

`Category` and `Rarity` enums let you layer on filtering, loot tables, color coding, etc. Example:

```gdscript
match InventoryItemConventions.category_for(id):
  InventoryItemConventions.Category.WEAPON:
    # equip logic
  InventoryItemConventions.Category.MATERIAL:
    # stacking / crafting logic
```

## 🧩 Extending

Ideas for next steps:

- Add `item_scene_path` values to each base entry for accurate restoration.
- Introduce rarity-weighted random selection helper.
- Add durability / stats dictionaries to `InventoryItemBase` (still immutable).
- Provide `InventoryItemFactory` for bulk generation with validation.

## 🛠 Development Notes

- Item base registry is static & loaded once; `get_item_spec` returns the original `InventoryItemBase`.
- Avoid mutating base objects at runtime; treat instances as the mutable surface.
- If you add new `ItemID` values, also add an entry to `ITEM_SPEC_DATA` or you’ll trigger errors when constructing.

## ✅ Quick Checklist

- [x] Centralized immutable item specs
- [x] Instance constructor pulls from base automatically
- [x] Pickup / drop / store / restore workflow
- [x] UI slot representation scaffold
- [ ] Icon paths populated
- [ ] Rarity-weighted loot distribution
- [ ] Save/load persistence layer wiring (InventoryHub serialization)

## 🤝 Contribution

PRs welcome. Keep item naming consistent and avoid magic numbers—prefer enums and helper methods.

## 📄 License

See `LICENSE` for details.
