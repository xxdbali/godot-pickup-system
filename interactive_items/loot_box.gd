extends RigidBody3D
# preload ItemSpec

# Use the global class_name InventoryItemConventions directly

@onready var label := Label3D.new()
var label_color := Color.WHITE
var label_text := InventoryItemConventions.name_for(InventoryItemConventions.ItemID.CRYSTAL_BLADE)
# Inventory item instance (created after choosing a base type)
var inventory_item_instance: InventoryItem

func _ready():
	randomize()

	var random_id: int = InventoryItemConventions.ITEM_ID_LIST[randi() % InventoryItemConventions.ITEM_ID_LIST.size()]
	# Create item instance from base spec (no need to set base fields here)
	inventory_item_instance = InventoryItem.new(random_id)
	# Only set instance-specific properties: qty, transform, inventory slot index
	inventory_item_instance.transform = self.transform
	if inventory_item_instance.is_stackable:
		inventory_item_instance.qty = randi_range(1, inventory_item_instance.max_stack)
	else:
		inventory_item_instance.qty = 1
	inventory_item_instance.inventory_slot_index = -1

	# Setup label
	label_text = inventory_item_instance.name
	label.text = label_text
	label.position = Vector3(0, 1, 0)
	label.modulate = Color(
		randf_range(0.3, 1.0),
		randf_range(0.3, 1.0),
		randf_range(0.3, 1.0)
	)
	label.font_size = 32
	add_child(label)
	
	
func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		label.look_at(camera.global_transform.origin, Vector3.UP)
		label.rotate_y(PI) # Flip around Y to face camera correctly


# Public accessor so other nodes can fetch the item instance safely
func get_inventory_item() -> InventoryItem:
	return inventory_item_instance
