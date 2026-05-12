extends Control

@onready var grid = $Background/ItemGrid
@onready var explain_sheet = $Background/ExplainSheet
@onready var delete_single = $Background/DeleteSheet_Single
@onready var delete_multiple = $Background/DeleteSheet_Multiple
@onready var use_single = $Background/UseSheet_Single
@onready var use_multiple = $Background/UseSheet_Multiple
@onready var scroll_single = $Background/ScrollSheet_Single
@onready var scroll_multiple = $Background/ScrollSheet_Multiple
@onready var error = $Background/error
@onready var character_sheet = $Background/Character
@onready var skill_sheet = $Background/Skill
@onready var summon_sheet = $Background/Summon
@onready var input_node_del = $Background/DeleteSheet_Multiple/InputNumber
@onready var input_node_use = $Background/UseSheet_Multiple/InputNumber
@onready var cat_inventory = $Background/Category/Cat_Inventory
@onready var cat_character = $Background/Category/Cat_Character
@onready var cat_skill = $Background/Category/Cat_Skill
@onready var cat_summon = $Background/Category/Cat_Summon
@onready var popup_layer: Control = $"../PopupLayer"

const SLOT_SCENE = preload("res://item_slot.tscn")
const SUMMON_POPUP_SCENE: PackedScene = preload("res://summon_popup.tscn")

var _summon_popup: Control = null
var current_selected_slot = null 

signal inventory_toggled(is_opened: bool)

func _ready():
	visible = false
	prepare_slots()
	
	InventoryData.add_item("scroll_slime1", 100)

func open():
	visible = true
	refresh()

func close():	# Close Inventory
	visible = false
	 # 닫을 때 정보,사용, 삭제창도 같이 닫기
	explain_sheet.hide_sheet()
	Sheet_Visible_Control(false, 0, "")
		
	# joystick 활성화
	inventory_toggled.emit(false)

func toggle():	# Inventory Toggle
	visible = !visible
	if visible:
		# joystick 비활성화
		inventory_toggled.emit(true)
		refresh()

func prepare_slots():
	# 기존에 혹시 있을지 모를 자식 노드 정리
	for child in grid.get_children():
		child.queue_free()

	# 48개의 슬롯을 딱 한 번만 미리 생성
	for i in range(48):
		var slot = SLOT_SCENE.instantiate()
		grid.add_child(slot)
		slot.slot_pressed.connect(_on_slot_selected)
	
	# 최초 인벤토리창을 열땐 아이템창이 눌러져있는 상태
	cat_inventory.button_pressed = true

@warning_ignore("unused_parameter")
func _on_slot_selected(data, slot_node):
	# 1. 이전에 선택된 슬롯이 있다면 강조 끄기
	if current_selected_slot != null:
		current_selected_slot.set_selected(false)

	# 2. 지금 클릭한 슬롯을 현재 선택으로 저장하고 강조 켜기
	current_selected_slot = slot_node
	current_selected_slot.set_selected(true)
	
	# 3. InputNumber 노드에 선택된 슬롯 알려줌
	input_node_del.selected_slot(slot_node)
	input_node_use.selected_slot(slot_node)
	
	# 4. 상세 정보창(ExplainSheet) 업데이트
	# 슬롯에 아이템 데이터가 있을 때만 표시
	if data and not data.is_empty():
		explain_sheet.display(data)
	else:
		explain_sheet.hide_sheet()
	
	# 5. Use/Delete 창 전시해제
	Sheet_Visible_Control(false, 0, "")
	
	# 6. 입력값 1로 초기화
	input_node_del.used()
	input_node_use.used()

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

# Use/Delete 창 전시 컨트롤
func Sheet_Visible_Control(flag: bool, count: int, type: String) -> void:
	if flag:
		if count == 1:
			if type == "Use":
				use_single.visible = flag
			elif type == "Delete":
				delete_single.visible = flag
			elif type == "Scroll":
				scroll_single.visible = flag
		else:
			if type == "Use":
				use_multiple.visible = flag
			elif type == "Delete":
				delete_multiple.visible = flag
			elif type == "Scroll":
				scroll_multiple.visible = flag
	else:
		use_single.visible = flag
		use_multiple.visible = flag
		delete_single.visible = flag
		delete_multiple.visible = flag
		scroll_single.visible = flag
		scroll_multiple.visible = flag
	
func _on_close_button_pressed() -> void:
	close()
	if current_selected_slot != null:
		current_selected_slot.set_selected(false)


func _on_trash_button_pressed() -> void:
	var index = current_selected_slot.get_index()
	var count = InventoryData.items[index].count
	
	Sheet_Visible_Control(true, count, "Delete")

func _on_ok_pressed(value: int = -1) -> void:
	var index = current_selected_slot.get_index()
	var is_scroll = InventoryData.items[index].id.begins_with("scroll_")
	
	if value == -1 || value == 1:
		# 현재 아이템이 1개 남았을 때 삭제하면 DB, 슬롯, 설명창 클리어
		if InventoryData.items[index].count == 1:
			InventoryData.items[index].count = 0
		else:
			# 입력값만큼 개수 차감
			InventoryData.items[index].count -= int(input_node_del.text)
		
		if is_scroll:
			var results: Array = SummonManager.make_summon_results(value, 1)
			show_summon_popup(results)
		
	elif value == 10:
		if InventoryData.items[index].count < 10:
			error.visible = true
		else:
			# 10개 차감
			InventoryData.items[index].count -= value
			
			if is_scroll:
				var results: Array = SummonManager.make_summon_results(value, 1)
				show_summon_popup(results)
	
	# explain_sheet 개수 최신화
	var ex_count :String = str(InventoryData.items[index].count)
	explain_sheet.item_count_label.text = "(소지 갯수: {0})".format([ex_count])
					
	# 차감 후 개수가 0개면 DB,슬롯,설명창 클리어
	if InventoryData.items[index].count == 0:
		InventoryData.items[index] = null
		current_selected_slot.clear_slot()
		explain_sheet.hide_sheet()
			
	# 삭제창 클리어
	Sheet_Visible_Control(false, 0, "")
		
	# 인풋값 1로 초기화
	input_node_del.used()
	input_node_use.used()
		
	# 아이템 개수 최신화
	refresh()

# 삭제 취소 -> 삭제창 클리어
func _on_cancel_pressed() -> void:
	Sheet_Visible_Control(false, 0, "")
	
	# 입력값 1로 초기화
	input_node_del.used()
	input_node_use.used()

func ChangeCategory(cat):
	# 모든 창 초기화
	grid.visible = false
	explain_sheet.visible = false
	character_sheet.visible = false
	skill_sheet.visible = false
	summon_sheet.visible = false
	
	# 수신한 카테고리 전시
	cat.visible = true
	# 아이템창이면 아이템 설명창도 전시
	if cat.name == "ItemGrid":
		explain_sheet.visible = true
	else:
		if current_selected_slot != null:
			current_selected_slot.set_selected(false)
		explain_sheet.hide_sheet()

func ChangeCatToggle(cat):
	# 토글 초기화
	cat_character.button_pressed = false
	cat_inventory.button_pressed = false
	cat_skill.button_pressed = false
	cat_summon.button_pressed = false

	# 토글모드 설정
	cat.button_pressed = true

func _on_cat_inventory_pressed() -> void:
	# category 토글 컨트롤
	ChangeCatToggle(cat_inventory)
	
	# 아이템창 전시
	ChangeCategory(grid)

func _on_cat_character_pressed() -> void:
	# category 토글 컨트롤
	ChangeCatToggle(cat_character)

	# 캐릭터창 전시
	ChangeCategory(character_sheet)

func _on_cat_skill_pressed() -> void:
	# category 토글 컨트롤
	ChangeCatToggle(cat_skill)
	
	# 캐릭터창 전시
	ChangeCategory(skill_sheet)

func _on_cat_summon_pressed() -> void:
	# category 토글 컨트롤
	ChangeCatToggle(cat_summon)
	
	# 소환수창 전시
	ChangeCategory(summon_sheet)
	
	# main/sub 소환수 전시
	summon_sheet.refresh_all_slots()

# 아에템 사용버튼
func _on_use_button_pressed() -> void:
	#var index = current_selected_slot.get_index()
	#var count = InventoryData.items[index].count
	
	#Sheet_Visible_Control(true, count, "Use")
	pass

# 소환서 사용버튼
func _on_scroll_button_pressed(value: int = 0) -> void:
	# 소환서는 1개, 10개 사용만 있으므로 count에 고정값 삽입
	if value != 0:
		Sheet_Visible_Control(true, value, "Scroll")
	else:
		print("scroll_button_value: ", value)

# 갯수가 모자른데 사용할 경우 에러
func _on_error_ok_pressed() -> void:
	error.visible = false
	
# 소환서 사용 시 팝업 호출
func show_summon_popup(results: Array) -> void:
	# 중복 방지(이미 떠있으면 제거하거나 무시)
	if is_instance_valid(_summon_popup):
		_summon_popup.queue_free()
		_summon_popup = null
		
	_summon_popup = SUMMON_POPUP_SCENE.instantiate()
	popup_layer.add_child(_summon_popup)
	
	# (선택) 팝업이 닫히면 참조 정리
	if _summon_popup.has_signal("closed"):
		_summon_popup.closed.connect(func(): _summon_popup = null)
		
	# 팝업에 결과 전달 (팝업 스크립트에 open() 만들어두면 됨)
	if _summon_popup.has_method("open"):
		_summon_popup.open(results)
