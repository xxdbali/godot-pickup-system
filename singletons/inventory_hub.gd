extends Node

# external class InventoryItem type array
var INVENTORY_SIZE := 20
var inventory: Array[InventoryItem] = []

signal inventory_changed(inventory: Array[InventoryItem])

func is_full() -> bool:
    if inventory.size() >= INVENTORY_SIZE:
        return true
    return false

func append(item_data: InventoryItem) -> void:
    print("Attempting to add item to inventory: ", item_data)
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
