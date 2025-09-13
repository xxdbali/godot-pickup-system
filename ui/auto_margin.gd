# res://ui/auto_margin.gd
extends MarginContainer

@export_range(0.0, 0.5, 0.001)
var horizontal_ratio: float = 1.0 / 16.0

@export_range(0.0, 0.5, 0.001)
var vertical_ratio: float = 1.0 / 16.0

@export var lock_uniform: bool = true

func _ready() -> void:
	_update_margins()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_margins()

func _update_margins() -> void:
	var vp_size: Vector2 = get_viewport_rect().size
	var h := int(vp_size.x * horizontal_ratio)
	var v := int(vp_size.x * (horizontal_ratio if lock_uniform else vertical_ratio))

	add_theme_constant_override("margin_left", h)
	add_theme_constant_override("margin_right", h)
	add_theme_constant_override("margin_top", v)
	add_theme_constant_override("margin_bottom", v)
