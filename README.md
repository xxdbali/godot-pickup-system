# Godot Pickup System (FPS) – Inventory, Loot & Persistence

This project is a modular FPS-style object pickup & loot system built in **Godot 4.4**, enhanced with an **inventory manager**, **item data conventions**, and foundations for a **save / restore flow**. It targets first‑person games needing dynamic interaction, stackable items, categorized loot, and a clean data-driven item model.

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
  - Inspector-driven configuration for loot boxes (exported enum)

- **Magnetic Pickup Behavior (Optional)**
  - `fly_to_the_player.gd` makes nearby loot gravitate to the player if inventory has space
  - Adjustable speed & activation radius

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

### Loot Boxes (Configurable)

`interactive_items/loot_box.gd` now exports an enum field:

```gdscript
@export var item_id: InventoryItemConventions.ItemID = InventoryItemConventions.ItemID.CRYSTAL_BLADE
```

This means every placed loot box can be configured in the Inspector to spawn any predefined item in the `ItemID` enum. When the scene runs, the script:

1. Instantiates an `InventoryItem` using the selected enum value.
2. Randomizes quantity if the item is stackable.
3. Displays a floating `Label3D` above it with the item name.

You can duplicate the loot box scene and assign different `item_id` values for quick prototyping of reward spots.

### Magnetic Fly-To-Player

`interactive_items/fly_to_the_player.gd` (attach to a `RigidBody3D` child or the loot object root) provides a QoL feature: when the player enters a radius (`collection_range`) the item accelerates toward the player at `fly_speed`—only if `InventoryHub` reports space (`InventoryHub.is_full()` returns false). The script tweaks `linear_damp` so the motion feels smooth.

Tuning tips:

| Property           | Suggestion                         |
| ------------------ | ---------------------------------- |
| `collection_range` | 4–6 for casual pickup; 2 for tight |
| `fly_speed`        | 2–5 for medium pace; >8 is snappy  |
| `linear_damp` end  | Increase if overshooting           |

You can combine this with standard pickup so fast players don't have to precisely collide with items.

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

## ➕ Adding a New Item

1. Open `types/inventory_item_conventions.gd`.
2. Add a new name to the `enum ItemID` (uppercase with underscores).
3. Create a new `InventoryItemBase.new(...)` entry in `ITEM_SPEC_DATA` using that enum key.
4. (Optional) Add an icon at `res://interactive_items/icons/` and use its path.
5. (Optional) Provide a scene for world spawning (`item_scene_path`).

If step 3 is skipped and you instantiate the ID, you'll hit a lookup error. Keeping enum + dictionary in sync is required.

For large sets, consider splitting the big dictionary into chunked files and merging them at runtime.

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

## ▶️ Quick Start / Running

1. Open the project in **Godot 4.4** (matches `project.godot` feature tag).
2. Ensure the autoloads `InputHub` and `InventoryHub` are present (already configured in `project.godot`).
3. Run the main scene (set in Project Settings -> Application -> Run).
4. Controls (see `project.godot`):

- Move: WASD
- Jump: Space
- Pick: E
- Drop: Q
- Store: F1 (or mapped key `ui_store`)
- Restore: R
- Toggle Inventory: I

If you duplicate loot boxes and assign different `item_id`s you can quickly test variety.

## 🧪 Testing Ideas (Manual)

- Pick up a stackable item multiple times; verify quantity randomization stays within `1..max_stack`.
- Fill inventory to capacity and observe fly-to-player stops engaging.
- Change `fly_speed` mid-run (remote inspector) to tune feel.
- Add a new enum entry and forget the dictionary row—confirm it errors (expected) then add the row to fix.

## 🔮 Future Enhancements (Roadmap)

- Weighted random loot table utility (rarity-aware)
- Save/Load serialization for `InventoryHub` (JSON or binary Resource)
- Per-item scripts (behavior injection) via `script_path` field
- Networking considerations (authoritative pickup) for multiplayer
- Accessibility: colorblind-friendly rarity indicators

---

Enjoy hacking on it. PRs and issue reports are welcome.

See `LICENSE` for details.
