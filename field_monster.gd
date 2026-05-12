extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var monster_id := "slime"

# 배회 설정
@export var move_speed := 60.0
@export var wander_radius := 50.0

var wander_center: Vector2
var move_target: Vector2

var wait_timer := 0.0
var is_waiting := false
var stuck_timer := 0.0
var last_position := Vector2.ZERO

var creature_data: Dictionary
var battle_stats: Dictionary

var current_hp: float


func _ready():
	last_position = global_position
	var monster_data = SummonManager.create_creature(monster_id)
	setup(monster_data)

func _physics_process(delta):
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

	current_hp = battle_stats.max_hp

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
