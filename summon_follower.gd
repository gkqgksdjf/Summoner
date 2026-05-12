extends CharacterBody2D

@export var move_speed: float = 140.0
@export var accel: float = 900.0
@export var friction: float = 1000.0
@export var follow_distance: float = 12.0
@export var catchup_distance: float = 90.0
@export var teleport_distance: float = 220.0
@export var wander_radius: float = 10.0
@export var repath_interval: float = 0.5

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var uid: int = -1
var owner_player: CharacterBody2D = null
var slot_index: int = 0

var base_offset: Vector2 = Vector2.ZERO
var target_point: Vector2 = Vector2.ZERO
var repath_timer: float = 0.0
var last_dir: Vector2 = Vector2.DOWN
var is_initialized: bool = false

func setup(creature_uid: int, player: CharacterBody2D, idx: int) -> void:
	is_initialized = false

	uid = creature_uid
	owner_player = player
	slot_index = idx

	var creature = SummonManager.get_creature(uid)
	if creature == null or creature.is_empty():
		return

	var frames = load(creature["frames_path"])
	anim.sprite_frames = frames
	#anim.scale = Vector2(1.0, 1.0)
	SpriteUtil.apply_normalized_scale(anim, frames, creature.name, 80.0)

	_set_base_offset()

	global_position = owner_player.global_position + base_offset
	target_point = global_position
	repath_timer = randf_range(0.0, repath_interval)
	last_dir = Vector2.DOWN

	# 여기서 play 하지 말고, 준비만 끝냄
	is_initialized = true

func _physics_process(delta: float) -> void:
	if not is_initialized:
		return
	if owner_player == null:
		return

	if global_position.distance_to(owner_player.global_position) > teleport_distance:
		global_position = owner_player.global_position + base_offset
		velocity = Vector2.ZERO
		target_point = global_position

	repath_timer -= delta
	if repath_timer <= 0.0:
		_update_target_point()
		repath_timer = repath_interval

	var to_target: Vector2 = target_point - global_position
	var dist: float = to_target.length()
	var desired_velocity := Vector2.ZERO

	if dist > catchup_distance:
		desired_velocity = to_target.normalized() * move_speed
	elif dist > follow_distance:
		desired_velocity = to_target.normalized() * (move_speed * 0.65)
	else:
		desired_velocity = Vector2.ZERO

	if desired_velocity != Vector2.ZERO:
		velocity = velocity.move_toward(desired_velocity, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
	_update_animation()

func _set_base_offset() -> void:
	match slot_index:
		0:
			base_offset = Vector2(-28, 24)
		1:
			base_offset = Vector2(28, 24)
		2:
			base_offset = Vector2(0, 38)
		_:
			base_offset = Vector2(0, 24)

func _update_target_point() -> void:
	if owner_player == null:
		return

	var center: Vector2 = owner_player.global_position + base_offset

	if owner_player.velocity.length() > 0.0:
		center += owner_player.velocity.normalized() * 8.0

	var random_offset := Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)

	target_point = center + random_offset

func _safe_play(anim_name: String, flip: bool) -> void:
	if not is_initialized:
		return
	if anim == null:
		return
	if anim.sprite_frames == null:
		return
	if not anim.sprite_frames.has_animation(anim_name):
		return

	anim.flip_h = flip

	# 이미 같은 애니메이션이면 다시 play 안 함
	if anim.animation == anim_name and anim.is_playing():
		return

	anim.play(anim_name)
	

func _update_animation() -> void:
	if not is_initialized:
		return
	if anim == null:
		return
	if anim.sprite_frames == null:
		return

	if velocity.length() > 5.0:
		last_dir = velocity.normalized()

	if velocity.length() <= 5.0:
		if abs(last_dir.x) > abs(last_dir.y):
			_safe_play("idle_right", last_dir.x < 0.0)
		elif last_dir.y < 0.0:
			_safe_play("idle_up", false)
		else:
			_safe_play("idle_down", false)
		return

	if abs(velocity.x) > abs(velocity.y):
		_safe_play("walk_right", velocity.x < 0.0)
	elif velocity.y < 0.0:
		_safe_play("walk_up", false)
	else:
		_safe_play("walk_down", false)
		
func update_slot_index(new_index: int) -> void:
	slot_index = new_index
	_set_base_offset()
