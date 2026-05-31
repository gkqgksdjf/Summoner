extends Node
class_name SummonStat

const GRADE_MULTIPLIER := {
	1: 1.0,
	2: 1.15,
	3: 1.30,
	4: 1.50
}

const GROWTH_TYPES := {
	"ATK_AS": {
		"str": 2.0,
		"agi": 2.0,
		"int": 0.0,
		"vit": 1.0
	},
	"ATK_SK": {
		"str": 0.0,
		"agi": 1.0,
		"int": 3.0,
		"vit": 1.0
	},
	"TANK_HP": {
		"str": 1.0,
		"agi": 0.0,
		"int": 0.0,
		"vit": 3.0
	},
	"TANK_DEF": {
		"str": 1.0,
		"agi": 0.0,
		"int": 0.0,
		"vit": 2.5
	},
	"SUP_HEAL": {
		"str": 0.0,
		"agi": 0.0,
		"int": 2.5,
		"vit": 1.0
	},
	"SUP_BUFF": {
		"str": 0.0,
		"agi": 0.5,
		"int": 2.0,
		"vit": 1.0
	},
	"SUP_DEBUFF": {
		"str": 0.0,
		"agi": 1.0,
		"int": 2.0,
		"vit": 1.0
	}
}

const HP_SCALE := 15.0
const ATK_SCALE := 3.0
const DEF_SCALE := 2.0
const ATTACK_SPEED_SCALE := 0.02
const CRIT_RATE_SCALE := 0.3
const SKILL_POWER_SCALE := 4.0
const SKILL_HASTE_SCALE := 0.5


static func get_grade_multiplier(grade: int) -> float:
	return GRADE_MULTIPLIER.get(grade, 1.0)


static func get_level_stats(base_stats: Dictionary, growth_type: String, grade: int, level: int) -> Dictionary:
	var result := base_stats.duplicate(true)

	var growth: Dictionary = GROWTH_TYPES.get(growth_type, GROWTH_TYPES["ATK_AS"])
	var grade_mul := get_grade_multiplier(grade)
	var level_count: int = maxi(level - 1, 0)

	result.str += growth.str * grade_mul * level_count
	result.agi += growth.agi * grade_mul * level_count
	result.int += growth.int * grade_mul * level_count
	result.vit += growth.vit * grade_mul * level_count

	return result

static func get_battle_stats(creature: Dictionary) -> Dictionary:
	var base_stats: Dictionary = creature.get("base_stats", {
		"str": 5.0,
		"agi": 5.0,
		"int": 5.0,
		"vit": 5.0
	})

	var level: int = creature.get("level", 1)
	var grade: int = creature.get("grade", 1)
	var growth_type: String = creature.get("growth_type", "ATK_AS")
	var tank_type: String = creature.get("tank_type", "")

	var stats := get_level_stats(base_stats, growth_type, grade, level)

	# IV 적용
	var ivs: Dictionary = creature.get("ivs", {})

	stats.str += ivs.get("str", 0)
	stats.agi += ivs.get("agi", 0)
	stats.int += ivs.get("int", 0)
	stats.vit += ivs.get("vit", 0)

	# 성격 적용
	var nature_id: String = creature.get("nature", "balanced")
	var nature_data: Dictionary = NatureData.get_nature_data(nature_id)

	var mods: Dictionary = nature_data.get("mods", {})

	stats.str *= mods.get("str", 1.0)
	stats.agi *= mods.get("agi", 1.0)
	stats.int *= mods.get("int", 1.0)
	stats.vit *= mods.get("vit", 1.0)

	var hp_scale := HP_SCALE
	var def_scale := DEF_SCALE

	if tank_type == "hp":
		hp_scale = 20.0
		def_scale = 1.3
	elif tank_type == "def":
		hp_scale = 10.0
		def_scale = 3.0

	var max_hp: float = 100.0 + stats.vit * hp_scale

	var atk: float = 10.0 + stats.str * ATK_SCALE
	atk *= mods.get("atk", 1.0)

	var def: float = 3.0 + stats.vit * def_scale
	def *= mods.get("def", 1.0)

	var attack_speed: float = 1.0 + stats.agi * ATTACK_SPEED_SCALE
	attack_speed *= mods.get("attack_speed", 1.0)

	var crit_rate: float = min(50.0, 5.0 + stats.agi * CRIT_RATE_SCALE)
	crit_rate *= mods.get("crit_rate", 1.0)

	var crit_damage: float = 1.5
	crit_damage *= mods.get("crit_damage", 1.0)

	var skill_power: float = 10.0 + stats.int * SKILL_POWER_SCALE
	skill_power *= mods.get("skill_power", 1.0)

	var skill_haste: float = min(40.0, stats.int * SKILL_HASTE_SCALE)
	skill_haste *= mods.get("skill_haste", 1.0)

	return {
		"str": round(stats.str),
		"agi": round(stats.agi),
		"int": round(stats.int),
		"vit": round(stats.vit),

		"max_hp": round(max_hp),
		"atk": round(atk),
		"def": round(def),

		"attack_speed": attack_speed,
		"crit_rate": crit_rate,
		"crit_damage": crit_damage,

		"skill_power": round(skill_power),
		"skill_haste": skill_haste
	}
