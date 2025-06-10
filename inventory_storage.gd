extends Node

var inventory: Array = []

func save_inventory_to_file(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		print("Failed to open save file.")
		return

	var data = []
	for item in inventory:
		data.append({
			"scene_path": item.scene_path,
			"transform": item.transform,
			"metadata": item.metadata
		})

	file.store_string(to_json(data))
	file.close()

func load_inventory_from_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Save file not found.")
		return

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	inventory.clear()
	for d in data:
		var item = InventoryItem.new()
		item.scene_path = d["scene_path"]
		item.transform = Transform3D(d["transform"])
		item.metadata = d["metadata"]
		inventory.append(item)
