extends CharacterBody2D
class_name FieldMonster

const DAMAGE_TEXT_SCENE = preload("res://Scripts/Battle/damage_text.tscn")

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
var stuck_timer := 0.0
var last_position := Vector2.ZERO

var creature_data: Dictionary
var battle_stats: Dictionary
var current_hp: float
var hp_bar_timer := 0.0

var monster_type = "passive"
var target = null
var target_slot := 0

var is_in_combat := false
var attack_range := 0
var attack_timer := 0.0

enum State { WANDER, WAIT, CHASE, ATTACK }
var state: State = State.WANDER

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

	match state:
		State.WANDER: _process_wander(delta)
		State.WAIT:   _process_wait(delta)
		State.CHASE:  _process_chase()
		State.ATTACK: _process_attack()


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

# -------------------------
# State 진입 헬퍼
# -------------------------
func _enter_wait() -> void:
	state = State.WAIT
	velocity = Vector2.ZERO
	wait_timer = randf_range(1.0, 3.0)
	play_idle_animation()

func _enter_wander() -> void:
	target = null
	velocity = Vector2.ZERO
	_enter_wait()

# -------------------------
# State 처리
# -------------------------
func _process_wander(delta: float) -> void:
	var dir = global_position.direction_to(move_target)
	velocity = dir * move_speed
	move_and_slide()

	var moved_distance = global_position.distance_to(last_position)
	if moved_distance < 1.0 and velocity.length() > 0.1:
		stuck_timer += delta
	else:
		stuck_timer = 0.0
	last_position = global_position

	if stuck_timer >= 1.0:
		stuck_timer = 0.0
		_enter_wait()
		return

	update_animation(dir)

	if global_position.distance_to(move_target) < 10.0:
		_enter_wait()

func _process_wait(delta: float) -> void:
	wait_timer -= delta
	if wait_timer <= 0:
		state = State.WANDER
		pick_new_target()

func _process_chase() -> void:
	if target == null:
		_enter_wander()
		return

	var distance = global_position.distance_to(target.global_position)

	if distance > chase_range:
		_enter_wander()
		return

	if distance <= attack_range:
		state = State.ATTACK
		velocity = Vector2.ZERO
		play_idle_animation()
		print(creature_data.name, " 공격 시작")
		return

	var dir = global_position.direction_to(target.global_position)
	velocity = dir * chase_speed
	move_and_slide()
	update_animation(dir)

func _process_attack() -> void:
	if target == null:
		is_in_combat = false
		state = State.WANDER
		return

	var distance = global_position.distance_to(target.global_position)
	is_in_combat = true

	if distance > attack_range:
		is_in_combat = false
		state = State.CHASE
		return

	look_at_target()

	attack_timer -= get_physics_process_delta_time()
	if attack_timer <= 0.0:
		attack_target()
		var atk_speed = battle_stats.get("attack_speed", 1.0)
		attack_timer = 1.0 / atk_speed

# -------------------------
# 애니메이션
# -------------------------
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

# -------------------------
# 감지
# -------------------------
func _on_detection_area_body_entered(body: Node2D) -> void:
	if monster_type != "aggressive":
		return
	if body.name != "Player":
		return
	target = body
	state = State.CHASE

# -------------------------
# 전투
# -------------------------
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

	if target != null:
		state = State.CHASE

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

# -------------------------
# 타겟 슬롯
# -------------------------
func set_target_slot(slot: int):
	var hud := get_tree().get_first_node_in_group("HUD")

	target_slot = slot

	if slot <= 0:
		target_ui.visible = false
		return

	target_ui.visible = true
	target_label.text = str(slot) + " : " + creature_data.name

	var visual = SummonVisualData.visual_data.get(
		creature_data.creature_id,
		SummonVisualData.visual_data["default"]
	)
	var label_height = visual.get("label_height", 35)

	var text_size = target_label.get_theme_font("font").get_string_size(
		target_label.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		target_label.get_theme_font_size("font_size")
	)

	var width = text_size.x + 20
	var height = 15

	target_ui.size = Vector2(width, height)
	background.size = Vector2(width, height + 1)
	target_label.size = Vector2(width, height - 5)
	target_ui.position = Vector2(-width / 2, -label_height)

	if hud and hud.has_method("show_portrait"):
		hud.show_portrait(creature_data.creature_id, target_slot)

func show_damage_text(amount: float):
	var dmg_text = DAMAGE_TEXT_SCENE.instantiate()
	get_parent().add_child(dmg_text)
	dmg_text.global_position = global_position + Vector2(0, -40)
	dmg_text.setup(round(amount))
