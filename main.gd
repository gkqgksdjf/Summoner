# village.gd 또는 맵의 루트 스크립트
extends Node2D

@onready var player = $"World/Player" # 플레이어 노드 경로
@onready var spawns = $"World/Spawns" # Marker2D들이 모여있는 부모 노드

func _ready():
	_place_player()

func _place_player():
	var tag = SceneManager.target_spawn_tag
	
	if tag != "" and spawns.has_node(tag):
		# 저장된 태그와 일치하는 노드를 찾아 그 위치로 이동
		var target_node = spawns.get_node(tag) as Marker2D
		player.global_position = target_node.global_position
	else:
		# 태그가 없거나 못 찾을 경우 기본 위치(예: 0번 자식)
		if spawns.get_child_count() > 0:
			player.global_position = spawns.get_child(0).global_position
