extends CharacterBody2D
class_name FieldMonster

const DAMAGE_TEXT_SCENE = preload("res://damage_text.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var target_label: Label = $TargetUI/TargetLabel
@onready var target_ui = $TargetUI
@onready var background = $TargetUI/Background
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var player = get_tree().get_first_node_in_group("Player")

@export var monster_id := "slime"

# 배회 설정
@export var move_speed := 60.0
@export var wander_radius := 50.0

# Detection & Chasing
@export var chase_speed := 60.0
@export var chase_range := 100.0

var wander_center: Vector2
var move_target: Vector2

var wait_timer := 0.0
var is_waiting := false
var stuck_timer := 0.0
var last_position := Vector2.ZERO

var creature_data: Dictionary
var battle_stats: Dictionary
var current_hp: float
var hp_bar_timer := 0.0

var monster_type = "passive"
var is_chasing := false
var is_attacking := false
var target = null
var target_slot := 0

var is_in_combat := false
var attack_range := 0
var attack_timer := 0.0

func _ready():
	last_position = global_position
	var monster_data = SummonManager.create_creature(monster_id)
	setup(monster_data)

func set_monster_type(type):
	monster_type = type

func _physics_process(delta):
	# HP바 자동 숨김
	if hp_bar.visible:
		hp_bar_timer -= delta
	
		if hp_bar_timer <= 0.0:
			hp_bar.visible = false

	if is_attacking:
		process_attack()
		return

	if is_chasing:
		process_chase()
		return
	
	if is_waiting:
		wait_timer -= delta

		if wait_timer <= 0:
			is_waiting = false
			pick_new_target()

		return

	var dir = global_position.direction_to(move_target)

	velocity = dir * move_speed

	move_and_slide()
	
	# 끼임 체크
	var moved_distance = global_position.distance_to(last_position)

	if moved_distance < 1.0 and velocity.length() > 0.1:
		stuck_timer += delta
	else:
		stuck_timer = 0.0

	last_position = global_position

	# 일정 시간 이상 못 움직이면 새 목적지 선택
	if stuck_timer >= 1.0:
		stuck_timer = 0.0
		start_wait()
		return

	update_animation(dir)

	# 목적지 도착 판정
	if global_position.distance_to(move_target) < 10.0:
		start_wait()


func setup(data: Dictionary) -> void:
	creature_data = data

	battle_stats = SummonStat.get_battle_stats(data)
	attack_range = creature_data.get("attack_range", 45.0)
	
	current_hp = battle_stats.max_hp
	hp_bar.max_value = battle_stats.max_hp
	hp_bar.value = current_hp
	hp_bar.visible = false

	var frames = load(creature_data.frames_path)

	if frames:
		sprite.sprite_frames = frames
		SpriteUtil.apply_normalized_scale(sprite, frames, data.name, 80.0)
		sprite.play("idle_down")
	
	wander_center = global_position
	pick_new_target()

func pick_new_target():
	var offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)

	move_target = wander_center + offset


func start_wait():
	velocity = Vector2.ZERO

	is_waiting = true

	wait_timer = randf_range(1.0, 3.0)

	play_idle_animation()


func update_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		sprite.animation = "walk_right"
		sprite.flip_h = dir.x < 0
	elif dir.y < 0:
		sprite.animation = "walk_up"
		sprite.flip_h = false
	else:
		sprite.animation = "walk_down"
		sprite.flip_h = false

	sprite.play()


func play_idle_animation():
	sprite.stop()

	if abs(velocity.x) > abs(velocity.y):
		sprite.animation = "idle_right"
	elif velocity.y < 0:
		sprite.animation = "idle_up"
	else:
		sprite.animation = "idle_down"

	sprite.play()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if monster_type != "aggressive":
		return
	
	if body.name != "Player":
		return
	
	target = body
	is_chasing = true

func process_chase():
	if target == null:
		stop_chase()
		return

	var distance = global_position.distance_to(target.global_position)

	# 너무 멀어지면 추적 포기
	if distance > chase_range:
		stop_chase()
		return

	var dir = global_position.direction_to(target.global_position)
	# 공격 거리 진입
	if distance <= attack_range:
		start_attack()
		return
	
	velocity = dir * chase_speed

	move_and_slide()
	update_animation(dir)
	
func stop_chase():

	is_chasing = false
	target = null

	velocity = Vector2.ZERO
	start_wait()

func start_attack():
	
	is_attacking = true
	velocity = Vector2.ZERO

	play_idle_animation()
	print(creature_data.name, " 공격 시작")

func process_attack():
	if target == null:
		stop_attack()
		return

	var distance = global_position.distance_to(target.global_position)
	is_in_combat = true

	# 다시 멀어지면 추적 복귀
	# debug
	#print("attack_range: ",attack_range)
	if distance > attack_range:
		stop_attack()
		is_chasing = true
		return

	look_at_target()

	attack_timer -= get_physics_process_delta_time()
	if attack_timer <= 0.0:
		attack_target()
		var atk_speed = battle_stats.get("attack_speed", 1.0)
		attack_timer = 1.0 / atk_speed

func stop_attack():
	is_attacking = false
	is_in_combat = false

func look_at_target():

	if target == null:
		return

	var dir = global_position.direction_to(target.global_position)

	play_idle_direction(dir)

func play_idle_direction(dir: Vector2):

	if abs(dir.x) > abs(dir.y):
		sprite.animation = "idle_right"
		sprite.flip_h = dir.x < 0
	elif dir.y < 0:
		sprite.animation = "idle_up"
		sprite.flip_h = false
	else:
		sprite.animation = "idle_down"
		sprite.flip_h = false

	sprite.play()

func attack_target():
	if target == null:
		return

	var damage = battle_stats.get("atk", 5.0)

	print(creature_data.name, " 공격!")

	target.take_damage(damage)

func take_damage(amount: float):
	current_hp -= amount

	if !is_in_combat:
		is_in_combat = true
	
	# HP바 표시
	hp_bar.visible = true
	hp_bar_timer = 3.0
	hp_bar.value = current_hp

	print(
		creature_data.name,
		" 피격: ",
		round(amount),
		" 남은 HP: ",
		round(current_hp)
	)
	
	show_damage_text(amount)

	# 소환수가 공격하면 타겟 변경
	if target != null:
		is_chasing = true

	if current_hp <= 0:
		die()

func die():
	var hud := get_tree().get_first_node_in_group("HUD")
	if hud:
		hud.clear_portrait(target_slot)
		hud.update_target_selection(target_slot, false)
		hud.current_target_slot = 0
	player.locked_targets.erase(target_slot)
	set_target_slot(0)
	
	print(creature_data.name, " 사망")
	queue_free()

# slot label
func set_target_slot(slot: int):
	var hud := get_tree().get_first_node_in_group("HUD")
	
	# 현재 공격중 몬스터면 슬롯 변경 금지
	target_slot = slot
	
	if slot <= 0:
		target_ui.visible = false
		return

	target_ui.visible = true

	if slot <= 0:
		target_label.text = ""
	else:
		target_label.text = (
		str(slot)
		+ " : "
		+ creature_data.name
		)
	
	# -------------------------
	# visual data
	# -------------------------
	var visual = SummonVisualData.visual_data.get(
		creature_data.creature_id,
		SummonVisualData.visual_data["default"]
	)

	var label_height = visual.get(
		"label_height",
		35
	)
	
	# 텍스트 길이 계산
	var text_size = target_label.get_theme_font("font").get_string_size(
		target_label.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		target_label.get_theme_font_size("font_size")
	)

	var width = text_size.x + 20
	var height = 15

	# 전체 크기 통일
	target_ui.size = Vector2(width, height)
	background.size = Vector2(width, height+1)
	target_label.size = Vector2(width, height-5)

	# 중앙 정렬
	target_ui.position = Vector2(
		-width / 2,
		-label_height
	)
	
	# 슬롯에 초상화 전시
	if hud and hud.has_method("show_portrait"):
		# 현재 플레이어가 선택해서 공격중인 슬롯이면
		# portrait 갱신 금지
		#if hud.current_target_slot != target_slot:
			hud.show_portrait(creature_data.creature_id, target_slot)
			
func show_damage_text(amount: float):
	var dmg_text = DAMAGE_TEXT_SCENE.instantiate()
	get_parent().add_child(dmg_text)
	dmg_text.global_position = global_position + Vector2(0, -40)
	dmg_text.setup(round(amount))
