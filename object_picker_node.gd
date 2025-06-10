# object_picker_node.gd
extends Node

# Expect the RayCast3D node itself to be set from the Inspector
@export var ray_cast: RayCast3D = null 

@export var pick_up_distance := 2.0 # How far the player can reach
@export var throw_force := 10.0    # Force to apply when throwing
@export var held_object_parent_node_path : NodePath # Path to a node that will act as the parent for the held object (e.g., a "Hand" Node3D)

var held_object: RigidBody3D = null
var camera: Camera3D = null # Reference to the player's camera

# Store original physics properties to restore them on drop
var original_gravity_scale: float = 1.0
var original_collision_layer: int = 1
var original_collision_mask: int = 1

signal object_picked_up(object_node: Node)
signal object_dropped(object_node: Node)

func _ready():
	# We no longer need to find the RayCast3D, as it's passed via @export
	if not ray_cast:
		push_error("ObjectPicker: RayCast3D node not assigned in the Inspector!")
		set_process(false)
		return

	# Find the Camera3D, which is typically a child of the CharacterBody3D
	camera = get_parent().find_child("Camera3D")
	if not camera:
		push_error("ObjectPicker: Could not find Camera3D. Make sure it's a child of the CharacterBody3D.")
		set_process(false)
		return

	# No need to set collision mask here if it's done in the editor
	# ray_cast.set_collision_mask_value(1, true)
	# ray_cast.set_collision_mask_value(2, false)
	# ray_cast.set_collision_mask_value(3, false)

	# Ensure raycast target_position matches pick_up_distance if you want them linked
	# However, if you set target_position in editor, you might want to remove this line.
	# Leaving it here as a reminder that these should be consistent.
	ray_cast.target_position = Vector3(0, 0, -pick_up_distance)


func _process(delta):
	if Input.is_action_just_pressed("pick"):
		if held_object:
			drop_object()
		else:
			attempt_pick_up()

func attempt_pick_up():
	# Check if the raycast is valid and enabled
	if not ray_cast or not ray_cast.is_enabled(): return

	# Force an update of the raycast to get the latest collision info
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		var hit_object = ray_cast.get_collider()

		# Check if the hit object is a RigidBody3D and has the "pickable" metadata
		if hit_object is RigidBody3D and hit_object.has_meta("pickable") and hit_object.get_meta("pickable") == true:
			pick_up_object(hit_object)
		# Example for interacting with Area3Ds if they have an 'interact' method
		elif hit_object is Area3D and hit_object.has_method("interact"):
			hit_object.interact()

func pick_up_object(object_to_pick: RigidBody3D):
	held_object = object_to_pick

	# Store original physics properties before modifying them
	original_gravity_scale = held_object.gravity_scale
	original_collision_layer = held_object.collision_layer
	original_collision_mask = held_object.collision_mask

	# Temporarily disable physics interaction for the held object
	held_object.gravity_scale = 0.0 # Stop gravity
	held_object.linear_velocity = Vector3.ZERO # Stop any current movement
	held_object.angular_velocity = Vector3.ZERO # Stop any current rotation
	held_object.collision_layer = 0 # Remove from all collision layers
	held_object.collision_mask = 0 # Stop colliding with anything

	# Reparent the object to the designated "hand" node (or camera as a fallback)
	var new_parent = get_node(held_object_parent_node_path) if held_object_parent_node_path else camera
	if new_parent:
		# Ensure the object is removed from its current parent before adding to the new one
		if held_object.get_parent():
			held_object.get_parent().remove_child(held_object)
		new_parent.add_child(held_object)
		
		# Position the object relative to the hand/camera for a "held" appearance
		held_object.global_transform = new_parent.global_transform # Start at parent's global transform
		held_object.position = Vector3(0, 0, -1) # Then offset locally (adjust as needed for your hand/object size)
	else:
		push_error("ObjectPicker: No valid parent node for held object. Set 'held_object_parent_node_path' or ensure camera exists.")

	emit_signal("object_picked_up", held_object)
	print("Picked up: ", held_object.name)

func drop_object():
	if not held_object: return

	# Store the object's current global transform (where it is in the world right now)
	var drop_transform = held_object.global_transform

	# Get the absolute root of the scene tree for reliable reparenting
	var world_root = get_tree().root 
	
	# Remove from its current parent (the hand/camera)
	if held_object.get_parent():
		held_object.get_parent().remove_child(held_object)
	
	# Add it back to the world root
	world_root.add_child(held_object)
	
	# Explicitly set its global transform to the drop position
	held_object.global_transform = drop_transform

	# Restore original physics properties to re-enable gravity and collisions
	held_object.gravity_scale = original_gravity_scale
	held_object.collision_layer = original_collision_layer
	held_object.collision_mask = original_collision_mask
	held_object.set_sleeping(false) # Wake up the physics body

	# Apply a force to "throw" the object
	if camera:
		var throw_direction = -camera.global_transform.basis.z # Throw forward from the camera's view
		held_object.apply_central_force(throw_direction * throw_force)
		# For an immediate "kick," you could use apply_central_impulse() instead:
		# held_object.apply_central_impulse(throw_direction * throw_force) 

	held_object = null # Clear the reference to the held object
	emit_signal("object_dropped", held_object)
	print("Dropped object.")
