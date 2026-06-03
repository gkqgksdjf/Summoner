extends CharacterBody2D

@export var speed := 300.0

@onready var joystick = $"/root/Ui/Joystick"
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var summon_followers = $"../SummonFollowers"

# 전투 스탯
var max_hp: float = 100.0
var current_hp: float = 100.0
var atk: float = 10.0
var def: float = 5.0
var attack_speed: float = 1.0

var is_dead := false

var combat_targets := {}
var current_target = null
var locked_targets := {}
var locked_slot := 0
var combat_refresh_timer := 0.0


var last_dir := Vector2.DOWN   # 기본 정면(아래)

func _ready() -> void:
	SceneManager.scene_changing.connect(_on_scene_changing)
	
func _physics_process(_delta):
	if is_dead:
		return

	var dir: Vector2 = joystick.direction
	velocity = dir * speed
	
	if dir != Vector2.ZERO:
		last_dir = dir
		play_walk_animation(dir)
	else:
		play_idle_animation()

	move_and_slide()
	
	combat_refresh_timer -= _delta
	if combat_refresh_timer <= 0.0:
		update_combat_targets()
		combat_refresh_timer = 3.0

func take_damage(amount: float) -> void:
	if is_dead:
		return

	var final_damage = max(1.0, amount - def)

	current_hp -= final_damage

	print("플레이어 피격:", final_damage)
	print("현재 HP:", current_hp)

	if current_hp <= 0:
		die()


func die() -> void:
	is_dead = true

	print("플레이어 사망")

	# 이후:
	# 마을 이동
	# 부활 처리
	# 사망 연출
	# 이계 시스템
	# 등을 여기 연결


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

func update_combat_targets():
	# 근처 몬스터 수집
	var nearby_monsters := []
	for node in get_tree().get_nodes_in_group("monster"):
		var monster: FieldMonster = node
		if not is_instance_valid(monster):
			continue

		# 이미 고정 슬롯이면 제외
		if monster in locked_targets.values():
			continue

		var distance = global_position.distance_to(
			monster.global_position
		)

		# 너무 멀면 제외
		if distance > 250.0:
			continue

		nearby_monsters.append({
			"monster": monster,
			"distance": distance
		})

	# 거리순 정렬
	nearby_monsters.sort_custom(
		func(a, b):
			return a.distance < b.distance
	)

	# 기존 슬롯 초기화
	combat_targets.clear()

	# 전투중 슬롯 복원
	for slot in locked_targets.keys():
		combat_targets[slot] = locked_targets[slot]

	# 빈 슬롯 채우기
	for data in nearby_monsters:
		var monster = data.monster
		var empty_slot := -1
		for i in range(1, 5):
			if not combat_targets.has(i):
				empty_slot = i
				break

		if empty_slot == -1:
			break

		combat_targets[empty_slot] = monster

	# 보스 1번 슬롯 처리
	for slot in combat_targets.keys():
		var monster = combat_targets[slot]
		if monster == null:
			continue
		
		if monster.monster_type == "boss":
			# 이미 1번이면 패스
			if slot == 1:
				break

			# 1번 슬롯 전투중이면 패스
			if combat_targets.has(1):
				var slot1_monster = combat_targets[1]
				if slot1_monster.is_in_combat:
					break

			# 자리 교체
			combat_targets[slot] = combat_targets.get(1, null)
			combat_targets[1] = monster
			break

	# 라벨 초기화
	for monster in get_tree().get_nodes_in_group("monster"):
		if monster in locked_targets.values():
			continue
		if is_instance_valid(monster):
			monster.set_target_slot(0)

	# 라벨 재적용
	for slot in combat_targets.keys():
		var monster = combat_targets[slot]
		if monster == null:
			continue
		
		if is_instance_valid(monster):
			monster.set_target_slot(slot)

func command_attack(slot: int):
	if not combat_targets.has(slot):
		return
	
	var target = combat_targets[slot]
	
	# 이전 고정 해제
	locked_targets.clear()
	# 현재 슬롯만 고정
	locked_targets[slot] = target
	
	summon_followers.command_attack(target)

func set_target(monster):
	current_target = monster

func _on_scene_changing() -> void:
	current_target = null
	locked_targets.clear()
	combat_targets.clear()
