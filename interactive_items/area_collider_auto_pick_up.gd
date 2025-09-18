# This script is on the Area3D child node
extends Area3D

func _ready():
	# Connect the signal from this Area3D to a function in this script
	body_entered.connect(self._on_body_entered)

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