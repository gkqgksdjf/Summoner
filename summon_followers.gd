extends Node2D

const FOLLOWER_SCENE = preload("res://Scripts/Summon/summon_follower.tscn")

@export var player_path: NodePath = NodePath("../Player")

var player: CharacterBody2D = null
var follower_nodes: Dictionary = {}

func _ready() -> void:
	player = get_node_or_null(player_path) as CharacterBody2D

	if player == null:
		push_error("Player node not found. player_path = " + str(player_path))
		return

	if not SummonManager.main_summons_changed.is_connected(refresh_followers):
		SummonManager.main_summons_changed.connect(refresh_followers)

	refresh_followers()

func refresh_followers() -> void:
	if player == null:
		return

	var main_creatures: Array = SummonManager.get_main_creatures()
	var valid_uids: Array = []

	for i in range(main_creatures.size()):
		var creature = main_creatures[i]
		if creature == null:
			continue

		var uid = creature["uid"]
		valid_uids.append(uid)

		if not follower_nodes.has(uid):
			var follower = FOLLOWER_SCENE.instantiate()
			add_child(follower)
			follower_nodes[uid] = follower
			follower.setup(uid, player, i)
		else:
			follower_nodes[uid].update_slot_index(i)

	for old_uid in follower_nodes.keys().duplicate():
		if old_uid not in valid_uids:
			follower_nodes[old_uid].queue_free()
			follower_nodes.erase(old_uid)

func command_attack(target):
	for follower in follower_nodes.values():
		follower.set_combat_target(target)
