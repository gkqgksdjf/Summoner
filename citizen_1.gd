extends CharacterBody2D

@export var speed = 50
@export var wander_range = 200
@export var stop_time = 2.5
var start_pos: Vector2
var target_pos: Vector2
var is_walking: bool = false
var is_waiting: bool = false
var last_dir

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_pos = global_position
	random_position()

func _process(_delta) -> void:
	if is_walking:
		var distance = global_position.distance_to(target_pos)
		
		if distance <5:
			stop()
			return

		var direction = (target_pos - global_position).normalized()
		velocity = direction * speed
		last_dir = direction
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_right")
			else:
				anim.play("walk_left")
		else:
			if direction.y > 0:
				anim.play("walk_forward")
			else:
				anim.play("walk_back")
			
		move_and_slide()
		
		if get_real_velocity().length() < speed * 0.4:
			stop()

func random_position():
	if is_waiting: return
	
	var offset = Vector2(
		randf_range(-wander_range, wander_range), 
		randf_range(-wander_range, wander_range)
		)
	
	target_pos = start_pos + offset
	is_walking = true

func stop():
	if is_waiting: return
	
	is_walking = false
	is_waiting = true
	velocity = Vector2.ZERO
	
	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			anim.play("idle_right")
		else:
			anim.play("idle_left")
	else:
		if last_dir.y > 0:
			anim.play("idle_foward")
		else:
			anim.play("idle_back")
	
	await get_tree().create_timer(stop_time).timeout
	
	is_waiting = false
	random_position()
