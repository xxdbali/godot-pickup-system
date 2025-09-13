extends Control
class_name inventory_ui

@export var categories: PackedStringArray = ["quick", "backpack", "quest"]
@export var start_hidden := true

# New: scenes and per-tab slot counts / layout
@export var slot_scene: PackedScene
@export var item_scene: PackedScene
@export var tab_slot_counts: Dictionary = {
	"quick": 10,
	"backpack": 30,
	"quest": 8,
}
@export var default_columns: int = 5
@export var per_tab_columns: Dictionary = {
	"quick": 5,
	"backpack": 6,
	"quest": 4,
}

const ICON_WOOD_PATH := "res://icons/wood.png"

@export var tabs: TabContainer

func _ready() -> void:
	# demo mount: quick tab, slot index 2
	if item_scene != null:
		var wood_tex := load(ICON_WOOD_PATH) as Texture2D
		if wood_tex == null:
			push_warning("inventory_ui: Could not load icon at %s" % ICON_WOOD_PATH)
		mount_item("quick", 2, {
			"item_id": "wood",
			"item_name": "Wood",
			"qty": 12,
			"icon": wood_tex
		})

	if start_hidden:
		hide()

func _find_first_tabcontainer() -> TabContainer:
	var queue: Array = [self]
	while queue.size() > 0:
		var n := queue.pop_front() as Node
		if n is TabContainer:
			return n as TabContainer
		for c in n.get_children():
			queue.push_back(c)
	return null

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

func _get_slot(tab_name: StringName, index: int) -> Node:
	var page := tabs.get_node_or_null(NodePath(tab_name)) as Control
	if page == null:
		return null
	var grid := page.get_node_or_null("grid") as GridContainer
	if grid == null:
		return null
	return grid.get_node_or_null("slot_%d" % index)

func mount_item(tab_name: StringName, index: int, props: Dictionary) -> void:
	var slot := _get_slot(tab_name, index)
	if slot == null:
		push_error("inventory_ui: slot not found: %s[%d]" % [String(tab_name), index])
		return
	# clear existing child if you want hard replace
	# for c in slot.get_children():
	#	c.queue_free()

	var item := item_scene.instantiate()
	# Optional props: item_id, item_name, qty, icon (Texture2D)
	if props.has("item_id"): item.item_id = props.item_id
	if props.has("item_name"): item.item_name = props.item_name
	if props.has("qty"): item.qty = int(props.qty)
	if props.has("icon"): item.icon = props.icon

	slot.add_child(item)

	# Ensure visual fills the slot and is visible
	if item is Control:
		var c := item as Control
		c.set_anchors_preset(PRESET_FULL_RECT)
		c.size_flags_horizontal = SIZE_EXPAND_FILL
		c.size_flags_vertical = SIZE_EXPAND_FILL
