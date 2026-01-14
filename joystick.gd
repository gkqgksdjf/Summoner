extends Node2D

@onready var touch: TouchScreenButton = %TouchBtn
@onready var init_pos: Marker2D = %InitPos

var radius := 60.0
var direction: Vector2 = Vector2.ZERO
var dragging := false
var touch_id := -1

func _ready():
	var viewport_size = get_viewport_rect().size
	global_position = Vector2(200, viewport_size.y - 200)
	init_pos.global_position = global_position
	touch.global_position = global_position

func _process(_delta):
	queue_redraw()
	if not dragging:  
		direction = Vector2.ZERO  
		touch.position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if touch_id == -1 and _is_in_joystick_zone(event.position):
				touch_id = event.index
				dragging = true
				_update_stick(event.position)
		else:
			if event.index == touch_id:
				_reset_stick()
																																	
	elif event is InputEventScreenDrag:
		if event.index == touch_id:
			_update_stick(event.position)

func _update_stick(screen_pos: Vector2):
	var local_pos = to_local(screen_pos)
	var offset = local_pos
	
	if offset.length() > radius:  
		offset = offset.normalized() * radius  
		
	touch.position = offset  
	direction = Vector2.ZERO if offset.length() < 5 else offset.normalized()

func _reset_stick():
	touch_id = -1
	dragging = false
	direction = Vector2.ZERO
	touch.position = Vector2.ZERO

func _draw():
	draw_arc(Vector2.ZERO, radius + 40, 0, TAU, 64, Color.POWDER_BLUE, 12)
	draw_circle(touch.position, 40, Color.SKY_BLUE)

func _is_in_joystick_zone(pos: Vector2) -> bool:
	var screen := get_viewport().get_visible_rect().size
		
	return (
		pos.x < screen.x * 0.3 and   # 왼쪽 40%
		pos.y > screen.y * 0.5       # 아래 50%
	)
