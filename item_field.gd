extends Area2D

# 1. 에디터에서 입력받을 아이템 ID
@export var item_id: String = ""

# 2. 자식 노드 참조
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _picked := false

func _ready() -> void:
	# 3. 데이터베이스에 해당 아이템이 있는지 확인
	if InventoryData.item_db.has(item_id):
		var data = InventoryData.item_db[item_id]
		
		# [이미지 설정]
		# AutoLoad(InventoryData)의 함수를 이용해 AtlasTexture 생성 및 적용
		sprite.texture = InventoryData.get_item_icon(data["icon_pos"], data["sheet"])

		# [충돌 범위 설정]
		# 새로운 원형 모양(Shape) 생성 (인스턴스 간 공유 방지)
		var new_circle = CircleShape2D.new()
		
		# 지름이 TILE_SIZE가 되도록 반지름(Radius)을 1/2로 설정
		new_circle.radius = InventoryData.TILE_SIZE1 / 2.0
		
		# 생성한 모양을 충돌 노드에 할당
		collision_shape.shape = new_circle
	else:
		print("경고: InventoryData에 존재하지 않는 아이템 ID입니다 -> ", item_id)

# 4. 플레이어와 충돌 시 처리
func _on_body_entered(body: Node2D) -> void:
	if _picked:
		return
	# 플레이어가 "Player" 그룹에 속해 있다고 가정
	if body.is_in_group("Player"):
		_picked = true
		
		# 다시 못먹게 막기
		# ✅ 시그널 처리 끝난 다음 프레임에 바꾸도록 deferred
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		
		# 목표 위치(플레이어쪽으로)
		#var target: Vector2 = body.global_position + Vector2(0, -16)
		# 아이템 위치 위로 변경
		var target: Vector2 =collision_shape.global_position + Vector2(0,-16)
		
		# 트윈: 이동 + 축소 + 페이드
		# 축소 삭제
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property(self, "global_position", target, 0.18)
		#t.tween_property(self, "scale", Vector2(0.2, 0.2), 0.18)
		t.tween_property(sprite, "modulate:a", 0.0, 0.2)
		t.set_parallel(false)
		
		# 끝나면 인벤토리 추가 + 팝업 + 삭제
		t.tween_callback(Callable(self, "_on_pick_tween_finished"))
		
func _on_pick_tween_finished() -> void:
	var ok := InventoryData.add_item(item_id, 1)

	if ok and InventoryData.item_db.has(item_id):
		#var item_name: String = InventoryData.item_db[item_id]["name"]
		var hud := get_tree().get_first_node_in_group("HUD")
		if hud and hud.has_method("show_toast"):
			hud.show_toast(item_id)
	
	queue_free()
		
		#if InventoryData.add_item(item_id):
			# 인벤토리에 추가 성공 시 월드에서 제거
		#	queue_free()
