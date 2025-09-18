# FontSizeAutoFit.gd — tedd KÖZVETLENÜL a Label-re (Godot 4.x)
extends Label

@export var min_size: int = 8
@export var max_size: int = 72
@export var watch_text_runtime: bool = true # ha futás közben változik a text

var _last_text := ""
var _last_area := Vector2.ZERO

func _ready() -> void:
	resized.connect(_fit) # reagál átméretezésre
	_fit()
	set_process(watch_text_runtime)

func _process(_dt: float) -> void:
	# csak akkor számol újra, ha ténylegesen változott valami
	if text != _last_text or size != _last_area:
		_fit()

func _measure(font_size: int, max_width: float) -> Vector2:
	var f: Font = get_theme_font("font") if get_theme_font("font") != null else get_theme_default_font()
	if autowrap_mode != TextServer.AUTOWRAP_OFF:
		# több soros mérés, a Label szélességére tördelve
		return f.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, max_width, font_size)
	else:
		# egysoros mérés
		return f.get_string_size(text, font_size)

func _fit() -> void:
	var area := size
	if area.x <= 0.0 or area.y <= 0.0:
		return

	var lo := min_size
	var hi := max_size
	var best := lo

	while lo <= hi:
		var mid := (lo + hi) >> 1
		var needed := _measure(mid, area.x)
		if needed.x <= area.x + 0.5 and needed.y <= area.y + 0.5:
			best = mid
			lo = mid + 1
		else:
			hi = mid - 1

	add_theme_font_size_override("font_size", best)
	_last_text = text
	_last_area = area
