extends CanvasLayer

@onready var toast_root: Control = $Toast
@onready var toast_panel: NinePatchRect = $Toast/ToastIcon
@onready var margin: MarginContainer = $Toast/ToastIcon/MarginContainer
@onready var toast_label: Label = $Toast/ToastIcon/MarginContainer/HBoxContainer/ToastLabel
@onready var toast_icon: TextureRect = $Toast/ToastIcon/MarginContainer/HBoxContainer/ToastItem
@onready var strategy_box: NinePatchRect = $StrategySlot/Box
@onready var skill_box: NinePatchRect = $SkillSlot/Box
@onready var target_buttons = [
	$TargetSlot/TargetButtons/TargetBtn1,
	$TargetSlot/TargetButtons/TargetBtn2,
	$TargetSlot/TargetButtons/TargetBtn3,
	$TargetSlot/TargetButtons/TargetBtn4
]
@onready var target_borders = [
	$TargetSlot/TargetButtons/TargetBtn1/SelectBorder,
	$TargetSlot/TargetButtons/TargetBtn2/SelectBorder,
	$TargetSlot/TargetButtons/TargetBtn3/SelectBorder,
	$TargetSlot/TargetButtons/TargetBtn4/SelectBorder
]

const TOAST_MIN_W := 300.0
const RIGHT_MARGIN := 20.0

var _toast_tween: Tween
var current_target_slot := -1

func _ready() -> void:
	add_to_group("HUD")
	SceneManager.scene_changing.connect(_on_scene_changing)

	# Toast(Control)를 화면 전체 컨테이너로 강제
	toast_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	toast_root.offset_left = 0
	toast_root.offset_top = 0
	toast_root.offset_right = 0
	toast_root.offset_bottom = 0

	# 실제 패널은 처음에 숨김
	toast_panel.hide()

	# ToastIcon 앵커 (오른쪽 중앙)
	toast_panel.anchor_left = 1.0
	toast_panel.anchor_right = 1.0
	toast_panel.anchor_top = 0.5
	toast_panel.anchor_bottom = 0.5


func show_toast(item_id: String) -> void:
	if not InventoryData.item_db.has(item_id):
		return

	var data = InventoryData.item_db[item_id]

	toast_label.text = data["name"]
	toast_icon.texture = InventoryData.get_item_icon(data["icon_pos"], data["sheet"])

	toast_panel.show()
	toast_panel.modulate.a = 1.0

	# 레이아웃 계산 완료 후 크기 적용
	await get_tree().process_frame
	_apply_toast_layout()

	if _toast_tween and _toast_tween.is_running():
		_toast_tween.kill()

	_toast_tween = create_tween()
	_toast_tween.tween_interval(1.0)
	_toast_tween.tween_property(toast_panel, "modulate:a", 0.0, 0.5)
	_toast_tween.tween_callback(func(): toast_panel.hide())


func _apply_toast_layout() -> void:
	var need := margin.get_combined_minimum_size()

	var pad_l := toast_panel.patch_margin_left
	var pad_r := toast_panel.patch_margin_right

	var w : float = max(TOAST_MIN_W, need.x + pad_l + pad_r)
	var h := need.y

	toast_panel.size = Vector2(w, h)

	# 오른쪽 고정 + 왼쪽 확장
	toast_panel.offset_right = -RIGHT_MARGIN
	toast_panel.offset_left  = -RIGHT_MARGIN - w

	# 세로 중앙 정렬
	toast_panel.offset_top    = -h * 0.5
	toast_panel.offset_bottom =  h * 0.5

# 작전/스킬 박스 오픈
func _on_strategy_open_btn_pressed(type: String) -> void:
	if type == "Strategy":
		strategy_box.visible = true
	elif type == "Skill":
		skill_box.visible = true

# 작전/스킬 박스 클로즈
func _on_strategy_close_btn_pressed(type: String) -> void:
	if type == "Strategy":
		strategy_box.visible = false
	elif type == "Skill":
		skill_box.visible = false

# 타겟 슬롯에 초상화 전시
func show_portrait(creatureId, slotNo) -> void:
	var portrait = SummonVisualData.portrait[creatureId]

	target_buttons[slotNo -1].texture_normal = portrait
	target_buttons[slotNo -1].texture_pressed = portrait
	
	# 현재 선택 슬롯이면 테두리 유지
	if current_target_slot == slotNo:
		target_borders[slotNo - 1].visible = true

func _on_target_btn_pressed(slot: int) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	
	if player == null:
		return
	
	update_target_selection(slot, true)
	player.command_attack(slot)

func update_target_selection(slot: int, flag: bool) -> void:
	var current_slot = slot - 1
	for i in range(target_borders.size()):
		if i == current_slot:
			target_borders[i].visible = flag
		else:
			target_borders[i].visible = false
		
		# slot == 0은 전부 false로 만드는 경우 (맵이동 시 초기화)
		if slot == 0:
			target_borders[i].visible = false
		

func clear_portrait(slot_no):
	if slot_no > 0:
		target_buttons[slot_no - 1].texture_normal = null
		target_buttons[slot_no - 1].texture_pressed = null

func _on_scene_changing() -> void:
	for slot in range(1,5):
		clear_portrait(slot)
		update_target_selection(slot, false)
	current_target_slot = -1
