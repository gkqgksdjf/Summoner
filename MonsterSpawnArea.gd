extends Node2D

@export var monster_id := "slime"
@export var monster_type := "passive"
@export var spawn_count := 5
@export var spawn_radius := 300.0
@export var min_spawn_distance := 40.0
@export var monster_scene: PackedScene
@export var monster_container_path: NodePath

func _ready():
	spawn_monsters()

func spawn_monsters():
	var container = get_node(monster_container_path)

	for i in range(spawn_count):
		var monster = monster_scene.instantiate()

		var data = SummonManager.create_creature(monster_id)
		
		container.add_child(monster)
		monster.set_monster_type(monster_type)

		# Spawn random position
		var spawn_pos := global_position

		var found := false

		for try_count in range(20):
			var offset = Vector2(
			randf_range(-spawn_radius, spawn_radius),
			randf_range(-spawn_radius, spawn_radius)
			)

			var candidate = global_position + offset

			var too_close := false

			for other in container.get_children():
				if other.global_position.distance_to(candidate) < min_spawn_distance:
					too_close = true
					break

			if not too_close:
				spawn_pos = candidate
				found = true
				break

		monster.global_position = spawn_pos
		
		monster.setup(data)
