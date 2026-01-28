extends Control

@onready var grid = $Background/ItemGrid
@onready var explain_sheet = $Background/ExplainSheet

var current_selected_slot = null 

const SLOT_SCENE = preload("res://item_slot.tscn")

func _ready():
	visible = false
	prepare_slots()

func open():
	visible = true
	refresh()

func close():
	visible = false
	explain_sheet.hide_sheet() # 닫을 때 정보창도 같이 닫기

func toggle():
	visible = !visible
	if visible:
		refresh()

func prepare_slots():
	# 기존에 혹시 있을지 모를 자식 노드 정리
	for child in grid.get_children():
		child.queue_free()

	# 88개의 슬롯을 딱 한 번만 미리 생성
	for i in range(88):
		var slot = SLOT_SCENE.instantiate()
		grid.add_child(slot)
		slot.slot_pressed.connect(_on_slot_selected)

@warning_ignore("unused_parameter")
func _on_slot_selected(data, slot_node):
	# 1. 이전에 선택된 슬롯이 있다면 강조 끄기
	if current_selected_slot != null:
		current_selected_slot.set_selected(false)

	# 2. 지금 클릭한 슬롯을 현재 선택으로 저장하고 강조 켜기
	current_selected_slot = slot_node
	current_selected_slot.set_selected(true)
	
	# 3. 상세 정보창(ExplainSheet) 업데이트
	# 슬롯에 아이템 데이터가 있을 때만 표시
	if data and not data.is_empty():
		explain_sheet.display(data)
	else:
		explain_sheet.hide_sheet()


func refresh():
	var slots = grid.get_children()

	for i in range(slots.size()):
		var slot = slots[i]

		if i < InventoryData.items.size():
			var item = InventoryData.items[i]
			if item != null and not item.is_empty():
				slot.set_item(item)
			else:
				slot.clear_slot()
		else:
			# 아이템이 없는 빈 칸: 슬롯을 비우는 함수 호출 (추가 필요)
			slot.clear_slot()

func _on_close_button_pressed() -> void:
	close()


func _on_trash_button_pressed() -> void:
	var index = current_selected_slot.get_index()
	InventoryData.items[index] = null
	
	current_selected_slot.clear_slot()
	explain_sheet.hide_sheet()
