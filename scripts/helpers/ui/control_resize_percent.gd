extends Control
@export_range(0.0, 1.0) var width_percent: float = 1.0
@export_range(0.0, 1.0) var height_percent: float = 1.0

func _ready() -> void:
    _resize()
    resized.connect(_resize)

func _resize() -> void:
    var parent_size = get_parent().size if get_parent() is Control else get_viewport().size
    size = Vector2(
        parent_size.x * width_percent,
        parent_size.y * height_percent
    )
