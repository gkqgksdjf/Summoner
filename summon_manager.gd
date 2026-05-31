extends Node

signal main_summons_changed

var last_uid: int = 0

# 실제 획득한 소환수 개체들
var creatures_db: Dictionary = {}

# 인벤토리
var main_slots: Array = [null, null, null]
var sub_slots: Array = [null, null, null, null, null, null, null, null, null, null]

# 서식지
var habitats := {
	"meeting_square": [],
	"grassland": [],
	"snowfield": [],
	"ruins": []
}

# 개체치 random
func generate_ivs() -> Dictionary:
	return {
		"str": randi_range(0, 5),
		"agi": randi_range(0, 5),
		"int": randi_range(0, 5),
		"vit": randi_range(0, 5)
	}

func _make_uid() -> int:
	last_uid += 1
	return last_uid

func create_creature(creature_id: String) -> Dictionary:
	if not SummonData.creatures_list.has(creature_id):
		push_error("creatures_list에 없는 creature_id: " + creature_id)
		return {}

	var base = SummonData.creatures_list[creature_id]
	var uid = _make_uid()

	var creature = {
		"uid": uid,
		"creature_id": creature_id,
		"name": base.name,
		"description": base.description,
		"frames_path": base.frames_path,
		"grade": base.grade,
		"habitat_type": base.habitat_type,
		"current_place": "none",
		
		# initialize temp value
		"role": base.get("role", "attacker"),
		"growth_type": base.get("growth_type", "ATK_AS"),
		"tank_type": base.get("tank_type", ""),
		"attack_range": base.get("attack_range", 45.0),

		"level": 1,
		"exp": 0,
		"current_hp": 0.0,
		
		"nature": NatureData.get_random_nature(),
		"ivs": generate_ivs(),

		"base_stats": base.get("base_stats", {
			"str": 5.0,
			"agi": 5.0,
			"int": 5.0,
			"vit": 5.0
		})
	}
	
	var battle_stats := SummonStat.get_battle_stats(creature)
	creature.current_hp = battle_stats.max_hp

	creatures_db[uid] = creature
	return creature

func make_summon_results(count: int, scroll_grade: int) -> Array:
	var results: Array = []
	var candidate_ids: Array = []

	for creature_id in SummonData.creatures_list.keys():
		var data = SummonData.creatures_list[creature_id]
		if data.grade == scroll_grade:
			candidate_ids.append(creature_id)
	
	if candidate_ids.is_empty():
		return results
	
	for i in range(count):
		var creature_id = candidate_ids[randi() % candidate_ids.size()]
		var creature = create_creature(creature_id)
		_place_on_acquire(creature)
		results.append(creature)

	return results

func _place_on_acquire(creature: Dictionary) -> void:
	var empty_index := get_empty_sub_slot()

	if empty_index != -1:
		sub_slots[empty_index] = creature.uid
		creature.current_place = "sub"
	else:
		if habitats["meeting_square"].size() < 100:
			habitats["meeting_square"].append(creature.uid)
			creature.current_place = "meeting_square"
		else:
			# 이 경우는 호출 전에 미리 체크하는 게 더 좋음
			push_error("서브칸과 임시서식지가 모두 가득 참")

func get_empty_sub_slot() -> int:
	for i in range(sub_slots.size()):
		if sub_slots[i] == null:
			return i
	return -1

func get_creature(uid: int) -> Dictionary:
	return creatures_db.get(uid)

func get_sub_creatures() -> Array:
	var arr: Array = []

	for uid in sub_slots:
		if uid == null:
			arr.append(null)
		else:
			arr.append(creatures_db[uid])

	return arr

func get_main_creatures() -> Array:
	var arr: Array = []

	for uid in main_slots:
		if uid == null:
			arr.append(null)
		else:
			arr.append(creatures_db[uid])
	
	return arr

func get_creature_battle_stats(uid: int) -> Dictionary:
	if not creatures_db.has(uid):
		return {}

	return SummonStat.get_battle_stats(creatures_db[uid])

func level_up_creature(uid: int, amount: int = 1) -> void:
	if not creatures_db.has(uid):
		return

	var creature: Dictionary = creatures_db[uid]
	creature.level += amount

	var battle_stats := SummonStat.get_battle_stats(creature)
	creature.current_hp = battle_stats.max_hp

	creatures_db[uid] = creature

func move_sub_to_main(uid):
	# 이미 메인에 있으면 종료
	if uid in main_slots:
		return false
	
	# 메인 빈칸 찾기
	for i in range(main_slots.size()):
		if main_slots[i] == null:
			main_slots[i] = uid
			creatures_db[main_slots[i]]["current_place"] = "main"
			
			# sub에서 제거
			for j in range(sub_slots.size()):
				if sub_slots[j] == uid:
					sub_slots[j] = null
					break
			
			main_summons_changed.emit()
			return true
		
	return false # 메인칸 가득참

func move_main_to_sub(uid):
	# 이미 메인에 있으면 종료
	if uid in sub_slots:
		return false
	
	# 메인 빈칸 찾기
	for i in range(sub_slots.size()):
		if sub_slots[i] == null:
			sub_slots[i] = uid
			creatures_db[sub_slots[i]]["current_place"] = "sub"
		
			# sub에서 제거
			for j in range(main_slots.size()):
				if main_slots[j] == uid:
					main_slots[j] = null
					break
					
			main_summons_changed.emit()
			return true
																																														
	return false # 메인칸 가득참

func change_slot(from_uid: int, to_uid: int) -> bool:
		if from_uid == to_uid:
			return false
	
		if not creatures_db.has(from_uid):
			return false
		if not creatures_db.has(to_uid):
			return false
		
		# sub칸은 main칸이랑만 교체 / main칸은 sub칸이랑만 교체
		var from_slot = creatures_db[from_uid].current_place
		var to_slot = creatures_db[to_uid].current_place
		if  from_slot == "sub":
			if to_slot != "main":
				return false
		elif from_slot == "main":
			if to_slot != "sub":
				return false
		
		# sub -> main 교체
		if from_slot == "sub" && to_slot == "main":
			var sub_index := sub_slots.find(from_uid)
			var main_index := main_slots.find(to_uid)
			
			if sub_index == -1:
				return false
			if main_index == -1:
				return false
			
			# 실제 슬롯 교체
			sub_slots[sub_index] = to_uid
			main_slots[main_index] = from_uid
		
			# 상태값 교체
			creatures_db[from_uid].current_place = "main"
			creatures_db[to_uid].current_place = "sub"
			main_summons_changed.emit()
			return true
		# main -> sub 교체
		elif from_slot == "main" && to_slot == "sub":
			var sub_index := sub_slots.find(to_uid)
			var main_index := main_slots.find(from_uid)
			
			if sub_index == -1:
				return false
			if main_index == -1:
				return false
				
			# 실제 슬롯 교체
			sub_slots[sub_index] = from_uid
			main_slots[main_index] = to_uid
			
			# 상태값 교체
			creatures_db[from_uid].current_place = "sub"
			creatures_db[to_uid].current_place = "main"
			main_summons_changed.emit()
			return true
		
		return false
