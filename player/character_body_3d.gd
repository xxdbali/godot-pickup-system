extends CharacterBody3D

@export var move_speed := 4.0
@export var sprint_speed := 6.0
@export var jump_force := 4.5
@export var gravity := 9.8
@export var crouch_height := 0.9
@export var normal_height := 1.8
@export var mouse_sensitivity := 0.0002
@export var fov_smoothness := 5.0

@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
@onready var collision_shape = $CollisionShape3D

var is_mouse_locked := true
var is_crouching := false
var pitch := 0.0
var target_fov := 70.0
var current_fov := 70.0

func _ready() -> void:
	# react to future mode switches (e.g., inventory UI toggles)
	# InputHub.mode_changed.connect(_on_mode_changed)
	# _on_mode_changed(InputHub.current_mode)
	pass

func _on_mode_changed(_m: int) -> void:
	# lock mouse while in gameplay, visible in UI/dialog/menu
	# is_mouse_locked = (_m == InputHub.Mode.GAMEPLAY)
	pass

func _process(delta: float) -> void:
	# mouse look only in gameplay and while locked
	if InputHub.in_gameplay() and InputHub.is_mouse_locked:
		var mouse_motion := Input.get_last_mouse_velocity()
		rotate_y(-mouse_motion.x * mouse_sensitivity)
		pitch = clamp(pitch - mouse_motion.y * mouse_sensitivity, deg_to_rad(-80), deg_to_rad(80))
		camera_pivot.rotation.x = pitch

	# smooth FOV always runs (pure visual)
	current_fov = lerp(current_fov, target_fov, fov_smoothness * delta)
	camera.fov = current_fov

	# keep body upright
	rotation.x = 0.0
	rotation.z = 0.0

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO

	if InputHub.in_gameplay():
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z
		if Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
		if Input.is_action_pressed("move_right"):
			direction += transform.basis.x

	direction = direction.normalized()

	var current_speed := move_speed
	if InputHub.in_gameplay() and Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
		target_fov = 80.0
	else:
		target_fov = 70.0

	# crouch only reacts in gameplay; otherwise keep last state
	if InputHub.in_gameplay() and Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		is_crouching = false
	collision_shape.shape.height = (crouch_height if is_crouching else normal_height)

	# horizontal velocity only from gameplay inputs; physics still runs
	var h_velocity := direction * current_speed
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z

	# gravity & jumping: only allow jump in gameplay, but gravity always applies
	if is_on_floor():
		if InputHub.in_gameplay() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	else:
		velocity.y -= gravity * delta

	move_and_slide()