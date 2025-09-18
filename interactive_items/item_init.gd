extends RigidBody3D

@onready var label := Label3D.new()
var inventory_item_instance: InventoryItem
@export var item_id: InventoryItemConventions.ItemID = InventoryItemConventions.ItemID.CRYSTAL_BLADE

func _ready():
	randomize()
	var path = self.scene_file_path
	inventory_item_instance = InventoryItem.new(item_id, path)
	inventory_item_instance.transform = self.transform
	if inventory_item_instance.is_stackable:
		inventory_item_instance.qty = randi_range(1, inventory_item_instance.max_stack)
	else:
		inventory_item_instance.qty = 1
	inventory_item_instance.inventory_slot_index = -1

	# Setup label
	label.text = inventory_item_instance.name
	label.position = Vector3(0, 1, 0)
	label.modulate = Color.SKY_BLUE
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
