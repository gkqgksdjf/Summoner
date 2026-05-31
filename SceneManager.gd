# SceneManager.gd
extends Node

# 다음 씬에서 플레이어가 나타날 스폰 태그
var target_spawn_tag: String = ""

func change_scene(path: String) -> void:
	# Area2D 충돌 중 씬 전환 에러 방지용
	get_tree().call_deferred("change_scene_to_file", path)
	
	# 3. TargetSlot 초기화
	var hud := get_tree().get_first_node_in_group("HUD")
	var player := get_tree().get_first_node_in_group("player")
	
	if hud:
		for slot in range(1, 5):
			hud.clear_portrait(slot)
			hud.update_target_selection(slot, false)
		hud.current_target_slot = 0
				
	if player:
		player.current_target = null
		player.locked_targets.clear()
		player.combat_targets.clear()
