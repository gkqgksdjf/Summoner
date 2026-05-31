# npc_idle.gd 하나로 통합
extends CharacterBody2D

@export var idle_animation: String = "default"

func _process(_delta):
	$AnimatedSprite2D.animation = idle_animation
	$AnimatedSprite2D.play()
