extends Node2D

@onready var label = $Label

var velocity := Vector2.ZERO
var gravity := 500.0

func setup(damage: int):

	label.text = str(damage)

	# 랜덤 좌우 + 위로 튕김
	velocity.x = randf_range(-80.0, 80.0)
	velocity.y = randf_range(-260.0, -200.0)

	# 크리티컬 느낌용 랜덤 회전 약간
	rotation_degrees = randf_range(-8.0, 8.0)

	# 자동 삭제
	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"scale",
		Vector2(1.3, 1.3),
		0.08
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.7
	).set_delay(0.3)

	tween.tween_callback(queue_free)

func _process(delta):

	velocity.y += gravity * delta

	position += velocity * delta
