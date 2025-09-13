extends Node

# external class InventoryItem type array

var inventory: Array[InventoryItem] = []

signal inventory_changed(inventory: Array)

func append(item_data: InventoryItem) -> void:
    # item_data can contain item_id, item_name, qty, icon (Texture2D)
    # You can expand this function to handle stacking, limits, etc.
    inventory.append(item_data)
    emit_signal("inventory_changed", inventory)
    print("Item added to inventory: ", item_data)

func is_empty() -> bool:
    return inventory.is_empty()

func pop_back() -> InventoryItem:
    if is_empty():
        return null
    var backed = inventory.pop_back()
    emit_signal("inventory_changed", inventory)
    return backed
