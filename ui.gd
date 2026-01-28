extends CanvasLayer

@onready var inventory_ui = $InventoryUI

func _on_inventory_button_pressed() -> void:
	inventory_ui.toggle()
