extends Control

signal slot_pressed(uid)

var uid: int = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: TextureButton = $Button
@onready var select_frame = $SelectFrame


func _ready():
	button.pressed.connect(_on_pressed)


func set_creature(creature: Dictionary):
	uid = creature.uid
	
	var frames: SpriteFrames = load(creature.frames_path)
	sprite.sprite_frames = frames
	sprite.play("idle_down")
	
	if SummonManager.creatures_db[uid].current_place == "sub":
		SpriteUtil.apply_normalized_scale(sprite, frames, creature.name, 350.0)
	elif SummonManager.creatures_db[uid].current_place == "main":
		SpriteUtil.apply_normalized_scale(sprite, frames, creature.name, 400.0)
	
	sprite.centered = true
	sprite.position = size * 0.5
	
	select_frame.visible = false

func clear_slot():
	uid = -1
	sprite.stop()
	sprite.sprite_frames = null
	select_frame.visible = false


func set_selected(v: bool):
	select_frame.visible = v


func _on_pressed():
	if uid != -1:
		emit_signal("slot_pressed", uid)
		
func has_creature() -> bool:
	return uid != null and uid != -1
