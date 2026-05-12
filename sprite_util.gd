# SpriteUtil.gd (Autoload)
extends Node

func apply_normalized_scale(
	sprite: AnimatedSprite2D,
	frames: SpriteFrames,
	anim_name: String,
	target_size: float
) -> void:
	if sprite == null:
		return
	if frames == null:
		return
	
	if not frames.has_animation("idle_down"):
		return
	
	if frames.get_frame_count("idle_down") <= 0:
		return
	
	var tex: Texture2D = frames.get_frame_texture("idle_down", 0)
	if tex == null:
		return
	
	var src: Vector2 = tex.get_size()
	var max_side: float = max(src.x, src.y)
	
	if max_side <= 0.0:
		return
	
	# 기본 크기
	var final_size: float = target_size
	
	# 개별 몬스터 보정
	if anim_name.find("골렘") != -1:
		final_size *= 2.5
	elif anim_name.find("바르칸") != -1:
		final_size *= 2.5
	elif anim_name.find("코르엘") != -1:
		final_size *= 0.4
	
	var s: float = final_size / max_side
	sprite.scale = Vector2(s, s)
