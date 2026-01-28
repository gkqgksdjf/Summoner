extends StaticBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta) -> void:
	anim.animation = "default"
	anim.play()
