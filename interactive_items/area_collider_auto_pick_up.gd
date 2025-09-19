# This script is on the Area3D child node
extends Area3D
# The speed at which the object will fly toward the player
@export var fly_speed: float = 2.0

# The range at which the object starts to fly toward the player
@export var collection_range: float = 5.0

var player: Node3D = null
var parent_rigidbody: RigidBody3D = null

# Flag to track the state of the object's behavior
var is_flying: bool = false

func _ready():
	# Connect the signal from this Area3D to a function in this script
	body_entered.connect(self._on_body_entered)

	parent_rigidbody = get_parent()
	if not parent_rigidbody is RigidBody3D:
		print("This script's parent is not a RigidBody3D.")
		return
		
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player not found in 'player' group.")

func _on_body_entered(body):
	# Get the parent of this Area3D. This is the gem itself.
	var parent_gem = get_parent()
	print("Body entered the gem's area: ", body.name)
	# Check if the colliding body is the player and the inventory is not full
	if body.is_in_group("player") and not InventoryHub.is_full():
		if parent_gem and parent_gem.has_method("get_inventory_item"):
			# Get the item data directly from the parent
			var item_data = parent_gem.get_inventory_item()
			
			# Append the data to the inventory
			InventoryHub.append(item_data)
			
			# Queue the parent for deletion
			parent_gem.queue_free()
			parent_gem = null
			print("Collected a " + item_data.name + "!")
		else:
			print("Error: Parent does not have a get_inventory_item() method.")

func _physics_process(_delta):
	if player == null or parent_rigidbody == null:
		return

	# Check the inventory status before performing any flying logic
	# This assumes InventoryHub is an Autoload singleton.
	if not InventoryHub.is_full():
		var direction_vector = player.global_position - parent_rigidbody.global_position

		if direction_vector.length() < collection_range:
			# If the object is not already flying, start the flying behavior
			if not is_flying:
				is_flying = true
				# Set a low linear_damp so the object doesn't stop
				parent_rigidbody.linear_damp = 0.0

			var normalized_direction = direction_vector.normalized()
			var velocity_vector = normalized_direction * fly_speed
			parent_rigidbody.linear_velocity = velocity_vector
	else:
		# If the inventory is full, stop the flying behavior
		if is_flying:
			is_flying = false
			# Apply a high linear_damp to make the object slow down due to drag
			parent_rigidbody.linear_damp = 1.0 # Adjust this value as needed for desired drag