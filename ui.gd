extends CanvasLayer

@onready var toast_root: Control = $Toast
@onready var toast_panel: NinePatchRect = $Toast/ToastIcon
@onready var margin: MarginContainer = $Toast/ToastIcon/MarginContainer
@onready var toast_label: Label = $Toast/ToastIcon/MarginContainer/HBoxContainer/ToastLabel
@onready var toast_icon: TextureRect = $Toast/ToastIcon/MarginContainer/HBoxContainer/ToastItem

const TOAST_MIN_W := 300.0
const RIGHT_MARGIN := 20.0

var _toast_tween: Tween

func _ready() -> void:
	add_to_group("HUD")

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
