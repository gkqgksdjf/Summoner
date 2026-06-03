# SceneManager.gd
extends Node

signal scene_changing

# 다음 씬에서 플레이어가 나타날 스폰 태그
var target_spawn_tag: String = ""

func change_scene(path: String) -> void:
	# UI,Player TargetSlot 초기화
	scene_changing.emit()
	
	# Area2D 충돌 중 씬 전환 에러 방지용
	get_tree().call_deferred("change_scene_to_file", path)
