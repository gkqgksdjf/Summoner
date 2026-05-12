extends Control

@onready var explain = $Explain
@onready var name_explain = $Explain/Name
@onready var join_button = $Explain/Join
@onready var change_button = $Explain/Change
@onready var join_label = $Explain/Join/Join
@onready var clear_label = $Explain/Join/Clear
@onready var change_label = $Explain/Change/Change
@onready var cancel_label = $Explain/Change/Cancel
@onready var change_main = $MainSummon/ChangeAction

var main_slot_nodes: Array = []
var sub_slot_nodes: Array = []
var status: Array = []
var selected_uid: int = -1
var second_selected_uid: int = -1
var is_selected
var pressed_change = false

enum SELECTED_TYPE {
	MAIN,
	SUB,
	ALL
}

func _ready() -> void:
	_cache_slot_nodes()
	_connect_slot_signals()
	refresh_all_slots()
	join_button.visible = false
	change_button.visible = false
	
func _cache_slot_nodes() -> void:
	main_slot_nodes = [
		$MainSummon/Main/Main1,
		$MainSummon/Main/Main2,
		$MainSummon/Main/Main3
	]

	sub_slot_nodes = [
		$SubSummon/Sub_first/Sub1,
		$SubSummon/Sub_first/Sub2,
		$SubSummon/Sub_first/Sub3,
		$SubSummon/Sub_first/Sub4,
		$SubSummon/Sub_first/Sub5,
		$SubSummon/Sub_second/Sub6,
		$SubSummon/Sub_second/Sub7,
		$SubSummon/Sub_second/Sub8,
		$SubSummon/Sub_second/Sub9,
		$SubSummon/Sub_second/Sub10
	]
	
	status = [
		$Explain/Status/STR/value,
		$Explain/Status/DEX/value,
		$Explain/Status/INT/value,
		$Explain/Status/VIT/value
	]

func _connect_slot_signals() -> void:
	for slot in main_slot_nodes:
		slot.slot_pressed.connect(_on_slot_pressed)

	for slot in sub_slot_nodes:
		slot.slot_pressed.connect(_on_slot_pressed)


func refresh_all_slots() -> void:
	refresh_main_slots()
	refresh_sub_slots()
	update_slot_selection()

func refresh_main_slots() -> void:
	var creatures = SummonManager.get_main_creatures()

	for i in range(main_slot_nodes.size()):
		var slot = main_slot_nodes[i]

		if creatures[i] == null:
			slot.clear_slot()
		else:
			slot.set_creature(creatures[i])

func refresh_sub_slots() -> void:
	var creatures = SummonManager.get_sub_creatures()

	for i in range(sub_slot_nodes.size()):
		var slot = sub_slot_nodes[i]

		if creatures[i] == null:
			slot.clear_slot()
		else:
			slot.set_creature(creatures[i])

func _on_slot_pressed(uid: int) -> void:
	# 교체버튼 안누른경우
	var change_flag = false
	
	if pressed_change:
		change_flag = SummonManager.change_slot(selected_uid, uid)
	else:
		change_flag = false
	
	# 교체를 하기위해 슬롯을 누른 경우에는 수행하지 않음.
	if change_flag:
		refresh_all_slots()
		return
		
	selected_uid = uid
	update_slot_selection()

func update_slot_selection() -> void:
	if selected_uid != -1:
		for slot in main_slot_nodes:
			slot.set_selected(slot.uid == selected_uid)
			if (slot.uid == selected_uid):
				is_selected = SELECTED_TYPE.MAIN
				
		for slot in sub_slot_nodes:
			slot.set_selected(slot.uid == selected_uid)
			if (slot.uid == selected_uid):
				is_selected = SELECTED_TYPE.SUB
		
		# 버튼 문구 토글
		if is_selected == SELECTED_TYPE.MAIN:
			clear_label.visible = true
			join_label.visible = false
		elif is_selected == SELECTED_TYPE.SUB:
			clear_label.visible = false
			join_label.visible = true
		
		# 설명창 전시
		explain.visible = true
		var creature = SummonManager.creatures_db[selected_uid]
		var nature_data = NatureData.get_nature_data(creature.nature)
		var nature_name = nature_data.name
		name_explain.text = "%s %s" % [nature_name, creature.name]
		if nature_data.grade == "rare":
			name_explain.text = "★ " + name_explain.text
		
		var stats: Dictionary = SummonStat.get_battle_stats(creature)
		status[0].text = str(stats.str)
		status[1].text = str(stats.agi)
		status[2].text = str(stats.int)
		status[3].text = str(stats.vit)
		
		join_button.visible = true
		change_button.visible = true
		change_label.visible = true
		cancel_label.visible = false
		change_main.visible = false
		set_slots_highlight(false, SELECTED_TYPE.MAIN)
		set_slots_highlight(false, SELECTED_TYPE.SUB)
		pressed_change = false

# sub->main / main->sub로 편성/해제
func _on_join_pressed() -> void:
	if selected_uid == null:
		return
	
	if SummonManager.creatures_db[selected_uid].current_place == "sub":
		SummonManager.move_sub_to_main(selected_uid)
	else:
		SummonManager.move_main_to_sub(selected_uid)
	
	refresh_all_slots()


func _on_change_pressed() -> void:
	if selected_uid == null:
		return
	
	if pressed_change:
		ToggleChangeButton(false)
	else:
		ToggleChangeButton(true)
	#else:
	#	pass

func ToggleChangeButton(active :bool) -> void:
		pressed_change = active
		cancel_label.visible = active
		change_label.visible = !active
		
		if SummonManager.creatures_db[selected_uid].current_place == "sub":
			set_slots_highlight(active, SELECTED_TYPE.MAIN)
		elif SummonManager.creatures_db[selected_uid].current_place == "main":
			set_slots_highlight(active, SELECTED_TYPE.SUB)

func set_slots_highlight(active: bool, type):
	if type == SELECTED_TYPE.SUB:
		for slot in sub_slot_nodes:
			var rect = slot.get_node("ReferenceRect")
			if slot.has_creature():
				rect.visible = active
	elif type == SELECTED_TYPE.MAIN:
		for slot in main_slot_nodes:
			var rect = slot.get_node("ReferenceRect")
			if slot.has_creature():
				rect.visible = active
