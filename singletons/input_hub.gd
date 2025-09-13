extends Node

enum Mode {GAMEPLAY, UI, DIALOG, MENU}

var is_mouse_locked: bool = true

var mode: int = Mode.GAMEPLAY:
	set = set_mode

signal mode_changed(mode: int)

func set_mode(m: int) -> void:
	if mode == m:
		return
	mode = m
	emit_signal("mode_changed", mode)

func in_gameplay() -> bool:
	return mode == Mode.GAMEPLAY

# lifecyce functions
func _ready():
	_apply_mouse_mode()

func _process(_delta: float) -> void:
	# Centralized input handling for the mouse toggle
	# You can call your singleton's game state function here.
	if Input.is_action_just_pressed("toggle_mouse"):
		is_mouse_locked = not is_mouse_locked
		_apply_mouse_mode()

func _apply_mouse_mode():
	if is_mouse_locked:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
