extends InventoryItemBase
class_name InventoryItem

@export var item_id: StringName # unique instance identifier, not the ItemID enum
@export var qty: int = 1
@export var transform: Transform3D
@export var inventory_slot_index: int = -1

func _init(p_base_entity_id: int, p_qty: int = 1, p_transform: Transform3D = Transform3D(), p_inventory_slot_index: int = -1) -> void:
	# Pull base fields from conventions by ID
	var base := InventoryItemConventions.get_item_spec(p_base_entity_id)
	# Fill inherited, immutable fields from the base
	base_entity_id = base.base_entity_id
	name = base.name
	is_stackable = base.is_stackable
	max_stack = base.max_stack
	category = base.category
	default_rarity = base.default_rarity
	icon_path = base.icon_path
	item_scene_path = base.item_scene_path

	# Set variable, per-instance fields
	qty = (max(1, p_qty) if is_stackable else 1)
	transform = p_transform
	inventory_slot_index = p_inventory_slot_index
