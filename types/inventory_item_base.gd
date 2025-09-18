extends Resource
class_name InventoryItemBase

# Base (type) definition for an inventory item
# Note: category and default_rarity are ints; use InventoryItemConventions enums as values.
@export var base_entity_id: int
@export var name: String
@export var is_stackable: bool = false
@export var max_stack: int = 1
@export var category: int
@export var default_rarity: int

func _init(
	p_id: int = -1,
	p_name: String = "",
	p_is_stackable: bool = false,
	p_max_stack: int = 1,
	p_category: int = 0,
	p_default_rarity: int = 0
) -> void:
	base_entity_id = p_id
	name = p_name
	is_stackable = p_is_stackable
	max_stack = (max(1, p_max_stack) if p_is_stackable else 1)
	category = p_category
	default_rarity = p_default_rarity