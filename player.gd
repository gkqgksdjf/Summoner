extends CharacterBody2D

@export var speed := 300.0

@onready var joystick = $"../../UI/Joystick"
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_dir := Vector2.DOWN   # 기본 정면(아래)

func _physics_process(_delta):
	var dir: Vector2 = joystick.direction
	velocity = dir * speed
	
	if dir != Vector2.ZERO:
		last_dir = dir
		play_walk_animation(dir)
	else:
		play_idle_animation()

	move_and_slide()
	
func play_walk_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		anim.animation = "walk_right"
		anim.flip_h = dir.x < 0
	elif dir.y < 0:
		anim.animation = "walk_up"
		anim.flip_h = false
	else:
		anim.animation = "walk_down"
		anim.flip_h = false
	
	anim.play()
	
func play_idle_animation():
	if abs(last_dir.x) > abs(last_dir.y):
		anim.animation = "idle_right"
		anim.flip_h = last_dir.x < 0
	elif last_dir.y < 0:
		anim.animation = "idle_up"
		anim.flip_h = false
	else:
		anim.animation = "idle_down"
		anim.flip_h = false

	anim.play()
