extends Node

@export var ray_cast: RayCast3D = null
@export var pick_up_distance := 2.0
@export var throw_force := 10.0
@export var held_object_parent_node_path: NodePath

var held_object: RigidBody3D = null
var camera: Camera3D = null

var original_gravity_scale: float = 1.0
var original_collision_layer: int = 1
var original_collision_mask: int = 1

signal object_picked_up(object_node: Node)
signal object_dropped(object_node: Node)

func _ready():
	if not ray_cast:
		push_error("RayCast3D node not assigned!")
		set_process(false)
		return

	camera = get_parent().find_child("Camera3D")
	if not camera:
		push_error("Could not find Camera3D.")
		set_process(false)
		return

	ray_cast.target_position = Vector3(0, 0, -pick_up_distance)

func _process(_delta):
	if Input.is_action_just_pressed("pick"):
		if held_object:
			drop_object()
		else:
			attempt_pick_up()
	elif Input.is_action_just_pressed("ui_store"):
		store_held_object_to_inventory()
	elif Input.is_action_just_pressed("ui_restore"):
		restore_last_inventory_item()

func attempt_pick_up():
	if not ray_cast or not ray_cast.is_enabled(): return
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		var hit_object = ray_cast.get_collider()
		if hit_object is RigidBody3D and hit_object.get_meta("pickable") == true:
			pick_up_object(hit_object)
		elif hit_object is Area3D and hit_object.has_method("interact"):
			hit_object.interact()

func pick_up_object(object_to_pick: RigidBody3D):
	held_object = object_to_pick
	original_gravity_scale = held_object.gravity_scale
	original_collision_layer = held_object.collision_layer
	original_collision_mask = held_object.collision_mask

	held_object.gravity_scale = 0.0
	held_object.linear_velocity = Vector3.ZERO
	held_object.angular_velocity = Vector3.ZERO
	held_object.collision_layer = 0
	held_object.collision_mask = 0

	var new_parent = get_node(held_object_parent_node_path) if held_object_parent_node_path else camera
	if new_parent:
		if held_object.get_parent():
			held_object.get_parent().remove_child(held_object)
		new_parent.add_child(held_object)
		held_object.global_transform = new_parent.global_transform
		held_object.position = Vector3(0, 0, -1)
	else:
		push_error("No valid parent for held object.")

	emit_signal("object_picked_up", held_object)
	print("Picked up: ", held_object.name)

func drop_object():
	if not held_object: return

	var drop_transform = held_object.global_transform
	var world_root = get_tree().root

	if held_object.get_parent():
		held_object.get_parent().remove_child(held_object)
	world_root.add_child(held_object)
	held_object.global_transform = drop_transform
	held_object.gravity_scale = original_gravity_scale
	held_object.collision_layer = original_collision_layer
	held_object.collision_mask = original_collision_mask
	held_object.set_sleeping(false)

	if camera:
		var throw_dir = - camera.global_transform.basis.z
		held_object.apply_central_force(throw_dir * throw_force)

	emit_signal("object_dropped", held_object)
	
	held_object = null
	print("Dropped object.")

func store_held_object_to_inventory():
	if not held_object:
		return

	if InventoryHub.is_full():
		print("Inventory is full.")
		return

	InventoryHub.append(held_object.get_inventory_item())
		
	held_object.queue_free()
	held_object = null
	print("Stored object to inventory.")

func restore_last_inventory_item():
	if InventoryHub.is_empty():
		print("Inventory is empty.")
		return
		
	if held_object:
		print("Already holding an object. Drop it first.")
		return

	var item = InventoryHub.pop_back()

	if !item:
		print("Inventory item popped is empty.")
		return

	if not item.item_scene_path:
		print("Inventory item has no scene path to instantiate in the world.")
		return

	var scene = load(item.item_scene_path)
	if not scene:
		print("Failed to load scene from inventory item.")
		return

	var instance = scene.instantiate() as RigidBody3D
	#instance.global_transform = item.transform

	get_tree().current_scene.add_child(instance)
	pick_up_object(instance)
	print("Restored and picked up item from inventory.")
