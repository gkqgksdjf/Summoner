extends Node
class_name BattleCalculator

static func calculate_basic_attack_damage(attacker: Dictionary, defender: Dictionary) -> float:
	var atk_stats := SummonStat.get_battle_stats(attacker)
	var def_stats := SummonStat.get_battle_stats(defender)

	var raw_damage: float = atk_stats.atk
	var reduced_damage: float = raw_damage - def_stats.def

	return max(1.0, reduced_damage)


static func calculate_skill_damage(attacker: Dictionary, defender: Dictionary, skill_multiplier: float = 1.0) -> float:
	var atk_stats := SummonStat.get_battle_stats(attacker)
	var def_stats := SummonStat.get_battle_stats(defender)

	var raw_damage: float = atk_stats.skill_power * skill_multiplier
	var reduced_damage: float = raw_damage - def_stats.def

	return max(1.0, reduced_damage)


static func calculate_heal(caster: Dictionary, heal_multiplier: float = 1.0) -> float:
	var stats := SummonStat.get_battle_stats(caster)
	return stats.skill_power * heal_multiplier
