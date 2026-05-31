# NatureData.gd
extends Node

const NORMAL_NATURE_CHANCE := 95
const RARE_NATURE_CHANCE := 5


const NATURES = {
	# 일반 성격
	"agile": {
		"name": "민첩한",
		"grade": "normal",

		"mods": {
			"agi": 1.10,
			"vit": 0.95
		}
	},

	"strong": {
		"name": "강인한",
		"grade": "normal",

		"mods": {
			"str": 1.10,
			"agi": 0.95
		}
	},

	"lucky": {
		"name": "행운의",
		"grade": "normal",

		"mods": {
			"crit_rate": 1.15,
			"def": 0.95
		}
	},

	"tough": {
		"name": "튼튼한",
		"grade": "normal",

		"mods": {
			"vit": 1.10,
			"agi": 0.95
		}
	},

	"smart": {
		"name": "영리한",
		"grade": "normal",

		"mods": {
			"int": 1.10,
			"str": 0.95
		}
	},

	"wild": {
		"name": "사나운",
		"grade": "normal",

		"mods": {
			"atk": 1.10,
			"def": 0.95
		}
	},

	"calm": {
		"name": "냉정한",
		"grade": "normal",

		"mods": {
			"skill_haste": 1.10,
			"attack_speed": 0.95
		}
	},

	"solid": {
		"name": "단단한",
		"grade": "normal",

		"mods": {
			"def": 1.10,
			"agi": 0.95
		}
	},

	"balanced": {
		"name": "균형잡힌",
		"grade": "normal",

		"mods": {}
	},


	# 희귀 성격
	"berserk": {
		"name": "광폭한",
		"grade": "rare",

		"mods": {
			"atk": 1.20,
			"def": 0.90
		}
	},

	"swift": {
		"name": "재빠른",
		"grade": "rare",

		"mods": {
			"attack_speed": 1.20,
			"move_speed": 1.15
		}
	},

	"guardian": {
		"name": "수호의",
		"grade": "rare",

		"mods": {
			"def": 1.20,
			"vit": 1.15
		}
	},

	"sage": {
		"name": "현자의",
		"grade": "rare",

		"mods": {
			"skill_power": 1.20,
			"int": 1.10
		}
	},

	"immortal": {
		"name": "불굴의",
		"grade": "rare",

		"mods": {
			"vit": 1.20,
			"def": 1.10
		}
	},

	"rampage": {
		"name": "폭주의",
		"grade": "rare",

		"mods": {
			"atk": 1.15,
			"crit_damage": 1.20
		}
	}
}


func get_random_nature() -> String:
	var roll = randi() % 100

	var pool = []

	if roll < RARE_NATURE_CHANCE:
		for id in NATURES:
			if NATURES[id]["grade"] == "rare":
				pool.append(id)
	else:
		for id in NATURES:
			if NATURES[id]["grade"] == "normal":
				pool.append(id)

	return pool.pick_random()


func get_nature_data(nature_id: String) -> Dictionary:
	return NATURES.get(nature_id, NATURES["balanced"])
