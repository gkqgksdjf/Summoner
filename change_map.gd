extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var spawn_tag: String # 다음 맵에서 찾을 Marker2D의 이름

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if target_scene_path != "":
			# 1. 어디로 나타날지 태그를 저장
			SceneManager.target_spawn_tag = spawn_tag
			# 2. 안전하게 씬 전환 (지난번 알려드린 call_deferred 적용)
			SceneManager.change_scene(target_scene_path)
