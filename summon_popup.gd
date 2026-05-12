extends Control

signal closed

var _skip_requested: bool = false

@onready var single_view = $Panel/Content/SingleView
@onready var multi_view = $Panel/Content/MultiView
@onready var ok_button = $Panel/Buttons/Ok
@onready var skip_button = $Panel/Buttons/Skip

func _ready():
	pass

func open(results: Array) -> void:
	_skip_requested = false
	
	if results.size() == 1:
		_show_single(results[0])
	else:
		_show_multi(results)

func _on_skip_pressed() -> void:
	_skip_requested = true

func _show_single(data: Dictionary) -> void:
	single_view.visible = true
	multi_view.visible = false

	var sprite: AnimatedSprite2D = single_view.get_node("AnimRoot/CenterContainer/Slime_Ef")
	var name_label: Label = single_view.get_node("AnimRoot/Box/Name")
	var desc_label: Label = single_view.get_node("AnimRoot/Box/Desc")
	
	#소환 이펙트 play
	sprite.play("default")
	
	await sprite.animation_finished
	
	# 이펙트 페이드아웃
	var t := create_tween()
	t.tween_property(sprite, "modulate:a", 0.0, 0.25)
	await t.finished
	
	# 프레임 생성 또는 load
	var frames: SpriteFrames = load(data.frames_path)
	sprite.sprite_frames = frames
	sprite.speed_scale = 1.5
	sprite.play("idle_down")
	
	# sprite 크기 보정
	SpriteUtil.apply_normalized_scale(sprite, frames, data.name, 450.0)
	
	sprite.modulate.a = 1.0 

	#name_label.text = data.name
	var nature_data = NatureData.get_nature_data(data.nature)
	var nature_name = nature_data.name
	name_label.text = "%s %s" % [nature_name, data.name]
	if nature_data.grade == "rare":
		name_label.text = "★ " + name_label.text
	desc_label.text = data.get("description", "")
	
	ok_button.visible = true
	ok_button.modulate.a = 0.0
	var tt := create_tween()
	tt.tween_property(ok_button, "modulate:a", 1.0, 0.2)
	await get_tree().process_frame
	_place_ok_center()
	
func _show_multi(results: Array) -> void:
	single_view.visible = false
	multi_view.visible = true
	
	var sprite: AnimatedSprite2D = multi_view.get_node("AnimRoot/CenterContainer/Slime_Ef")
	
	#소환 이펙트 play
	sprite.play("default")

	await sprite.animation_finished
	
	# 이펙트 페이드아웃
	var t := create_tween()
	t.tween_property(sprite, "modulate:a", 0.0, 0.25)
	await t.finished

	_skip_requested = false
	skip_button.visible = true

	var grid = multi_view.get_node("Grid")
	grid.add_theme_constant_override("h_separation", 2)
	grid.add_theme_constant_override("v_separation", 150)
	_clear_children(grid) # 기존 셀 정리용 함수 따로 만들면 좋음

	for data in results:
		var cell = _create_cell(data)
		#cell.visible = false
		grid.add_child(cell)
		
		var tw := create_tween()
		tw.tween_property(cell, "modulate:a", 1.0, 0.2)
		
		if _skip_requested:
			continue
		
		# 1초마다 1개씩 공개
		await get_tree().create_timer(0.7).timeout
	
	skip_button.visible = false
	ok_button.visible = true

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
		
func _create_cell(data: Dictionary) -> Control:
	var cell_w: float = 260.0
	var cell_h: float = 210.0
	var label_h: float = 5.0

	var cell := VBoxContainer.new()
	cell.custom_minimum_size = Vector2(cell_w, cell_h)
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cell.alignment = BoxContainer.ALIGNMENT_CENTER
	cell.add_theme_constant_override("separation", 0)

	var holder := Control.new()
	holder.custom_minimum_size = Vector2(cell_w, cell_h - label_h)
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var sprite := AnimatedSprite2D.new()
	sprite.centered = true

	var frames: SpriteFrames = load(data.frames_path)
	sprite.sprite_frames = frames

	if frames != null and frames.has_animation("idle_down") and frames.get_frame_count("idle_down") > 0:
		sprite.play("idle_down")
		
	# sprite 크기보정
	SpriteUtil.apply_normalized_scale(sprite, frames, data.name, 260.0)

	var intensity: float = 6.0
	sprite.modulate = Color(intensity, intensity, intensity, 1.0)

	holder.add_child(sprite)
	
	sprite.position = holder.custom_minimum_size * 0.5

	holder.resized.connect(func():
		sprite.position = holder.size * 0.5
	)

	var label := Label.new()
	var font_file: FontFile = load("res://UI/Font/Probly8Denser-CJK.ttf")
	label.add_theme_font_override("font", font_file)
	
	var nature_data = NatureData.get_nature_data(data.nature)
	var nature_name = nature_data.name
	label.text = "%s %s" % [nature_name, data.name]
	if nature_data.grade == "rare":
		label.text = "★ " + label.text
	
	label.add_theme_font_size_override("font_size", 50)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.modulate = Color(intensity, intensity, intensity, 1.0)

	cell.add_child(holder)
	cell.add_child(label)

	cell.modulate.a = 0.0

	return cell

func _on_ok_pressed():
	emit_signal("closed")
	queue_free()
	
func _make_top_row_frames(sheet: Texture2D, cell_w: int, cell_h: int) -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.set_animation_speed("default", 1.5)
	frames.set_animation_loop("default", true)

	for x in range(4):
		var at := AtlasTexture.new()
		at.atlas = sheet
		at.region = Rect2(x * cell_w, 0, cell_w, cell_h)
		frames.add_frame("default", at)

	return frames

func _place_ok_center():
	# 앵커를 패널 중앙으로
	ok_button.anchor_left = 0.5
	ok_button.anchor_right = 0.5
	ok_button.anchor_top = 1.0
	ok_button.anchor_bottom = 1.0
						
	# 버튼 크기 기준으로 정확히 가운데 정렬
	ok_button.offset_left = -ok_button.size.x * 0.5
	ok_button.offset_right = ok_button.size.x * 0.5
	
	# 패널 아래쪽에서 약간 위로
	ok_button.offset_top = -80
	ok_button.offset_bottom = -20
