extends Control

@onready var icon = $Icon
@onready var slot_bg = $slot
@onready var selection_rect = $Selection

var item_data = {}

signal slot_pressed(slot_data, slot_note)

func _ready() -> void:
	slot_bg.visible = true
	selection_rect.visible = false

# item_slot.gd
func set_item(item: Dictionary = {}):
	item_data = item
	icon.texture = item["icon"]
	icon.visible = true

func clear_slot():
	item_data = null
	icon.texture = null
	icon.visible = false
	set_selected(false)

func set_selected(is_selected: bool):
	selection_rect.visible = is_selected

# 노드에 마우스 클릭 이벤트 연결 (Gui Input)
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# 부모(InventoryUI)에게 나 클릭됐다고 알림
			slot_pressed.emit(item_data, self)
