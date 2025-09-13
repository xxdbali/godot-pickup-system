extends TextureRect
class_name inventory_item

@export var item_id: StringName
@export var item_name: String
@export var qty: int = 1:
	set = set_qty

@export var icon: Texture2D:
	set = set_icon

@export var drag_preview_scale: float = 0.9

func _ready() -> void:
	# Fill parent slot and display properly
	set_anchors_preset(PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	if has_node("%qty"):
		var lbl := %qty
		lbl.visible = qty > 1
		lbl.text = str(qty)

func set_qty(v: int) -> void:
	qty = v
	if has_node("%qty"):
		var lbl := %qty
		lbl.visible = qty > 1
		lbl.text = str(qty)

func set_icon(tex: Texture2D) -> void:
	icon = tex
	texture = icon

func get_drag_data(_at_position: Vector2) -> Variant:
	var data := {
		"type": "inventory_item",
		"node": self
	}
	var preview := TextureRect.new()
	preview.texture = texture
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	preview.size = size * drag_preview_scale
	set_drag_preview(preview)
	return data
