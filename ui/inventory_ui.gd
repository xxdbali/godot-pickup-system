extends Control
class_name inventory_ui

@export var categories: PackedStringArray = ["quick", "backpack", "body"]
@export var quick_access_instance: NodePath
@export var backpack_instance: NodePath
@export var body_instance: NodePath

@export var start_hidden := true

# New: scenes and per-tab slot counts / layout
@export var slot_scene: PackedScene
@export var inventory_item_scene: PackedScene
@export var tab_slot_counts: Dictionary = {
	"quick": 10,
	"backpack": 30,
	"body": 8,
}
@export var default_columns: int = 5
@export var per_tab_columns: Dictionary = {
	"quick": 5,
	"backpack": 6,
	"body": 4,
}

const ICON_WOOD_PATH := "res://icons/wood.png"

@export var tabs: TabContainer

func _ready() -> void:
	if start_hidden:
		hide()
	InventoryHub.inventory_changed.connect(_on_inventory_changed)

func _on_inventory_changed(inventory: Array[InventoryItem]) -> void:
	print("Inventory updated, total items: %d" % inventory.size())
	_clear_icons_in_slot_list(backpack_instance)
	_fill_icons_in_slot_list(backpack_instance, inventory)

func _clear_icons_in_slot_list(slot_list_instance: NodePath) -> void:
	var container := get_node_or_null(slot_list_instance)
	if container == null:
		push_warning("inventory_ui: slot_list_instance not found: %s" % String(slot_list_instance))
		return

	#find all nested inventory_slot instances by group inventory_item_slot in the conotainer
	var all_slots := container.get_tree().get_nodes_in_group("inventory_item_slot")
	for slot in all_slots:
		var all_items := slot.get_tree().get_nodes_in_group("inventory_item")
		for item in all_items:
			item.queue_free()

func _fill_icons_in_slot_list(slot_list_instance: NodePath, inventory: Array[InventoryItem]) -> void:
	var container := get_node_or_null(slot_list_instance)
	if container == null:
		push_warning("inventory_ui: slot_list_instance not found: %s" % String(slot_list_instance))
		return
	#find all nested inventory_slot instances by group inventory_slot_mount_item in the conotainer
	var all_slots := container.get_tree().get_nodes_in_group("inventory_item_slot")
	print("Total slots found: %d" % all_slots.size())
	for i in range(min(inventory.size(), all_slots.size())):
		var item_data := inventory[i]
		# check if slot index exists if not just continue
		if item_data.inventory_slot_index > all_slots.size() - 1:
			continue
		print("Placing item %s in slot index %d" % [item_data.name, item_data.inventory_slot_index])
		if item_data.inventory_slot_index < 0:
			item_data.inventory_slot_index = _find_next_free_slot_index(all_slots)
		print("After check, item %s in slot index %d" % [item_data.name, item_data.inventory_slot_index])
		if item_data.inventory_slot_index == -1:
			print("No free slot found for item: %s" % item_data.name)
			continue

		var slot := all_slots[item_data.inventory_slot_index] as Node
		var slot_mounting_node := slot.get_tree().get_nodes_in_group("inventory_slot_mount_item")
		var item := inventory_item_scene.instantiate()
		slot_mounting_node[0].add_child(item)
		
		var icon_holder := item.get_tree().get_nodes_in_group("inventory_item_icon")
		icon_holder[0].texture = load(item_data.icon_path)
		var icon_label := item.get_tree().get_nodes_in_group("inventory_item_label")
		icon_label[0].text = str(item_data.qty)
		

func _find_next_free_slot_index(all_slots: Array[Node]) -> int:
	for i in range(all_slots.size()):
		var slot := all_slots[i]
		var existing_items := slot.get_tree().get_nodes_in_group("inventory_item")
		if existing_items.size() == 0:
			return i
	return -1
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_toggle_inventory"):
		_toggle_inventory()

func _toggle_inventory() -> void:
	visible = not visible
	Input.action_press("toggle_mouse")
	call_deferred("_release_toggle_mouse")
	InputHub.mode = InputHub.Mode.UI if visible else InputHub.Mode.GAMEPLAY

func _release_toggle_mouse() -> void:
	Input.action_release("toggle_mouse")
