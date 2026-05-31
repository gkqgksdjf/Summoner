extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var visual_data = {

	"default": {
		"label_height": 35
	},

	"golem": {
		"label_height": 60
	},

	"crystal_golem": {
		"label_height": 60
	},

	"varkan": {
		"label_height": 60
	}
}

var portrait = {
	"slime": preload("res://Summon_Portrait/Slime.png"),
	"golem": preload("res://Summon_Portrait/Golem.png"),
	"corel": preload("res://Summon_Portrait/Corel.png")
}
