extends Node

func _ready():
	pass


var creatures_list = {
	# --------------------
	# Slime 9
	# --------------------
	"slime": {
		"name": "슬라임",
		"description": "어디서나 흔히 볼 수 있는 말랑말랑한 생물로, 작지만 끈질긴 생명력을 가지고 있다.",
		"frames_path": "res://Summon_Anim/Slime1.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "tank",
		"growth_type": "TANK_HP",
		"tank_type": "hp",
		"base_stats": {"str": 4.0, "agi": 3.0, "int": 2.0, "vit": 8.0},
		"attack_range": 1.0
	},
	"bomb_slime": {
		"name": "폭탄 슬라임",
		"description": "몸속에 불안정한 마력을 품은 슬라임으로, 충격을 받으면 폭발적인 힘을 방출한다.",
		"frames_path": "res://Summon_Anim/Slime_Bomb.tres",
		"grade": 2,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 5.0, "agi": 3.0, "int": 7.0, "vit": 4.0}
	},
	"poison_slime": {
		"name": "포이즌 슬라임",
		"description": "독성이 강한 체액을 지닌 슬라임으로, 늪지의 오염된 환경에 적응해 살아간다.",
		"frames_path": "res://Summon_Anim/Slime_Poison.tres",
		"grade": 2,
		"habitat_type": "swamp",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 5.0, "int": 7.0, "vit": 5.0}
	},
	"fire_slime": {
		"name": "파이어 슬라임",
		"description": "뜨거운 불꽃 기운을 품은 슬라임으로, 몸 주변에 약한 열기를 내뿜는다.",
		"frames_path": "res://Summon_Anim/Slime_Fire.tres",
		"grade": 2,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 4.0, "agi": 4.0, "int": 8.0, "vit": 4.0}
	},
	"ice_slime": {
		"name": "아이스 슬라임",
		"description": "차가운 냉기를 품은 슬라임으로, 설원에서도 얼어붙지 않고 움직인다.",
		"frames_path": "res://Summon_Anim/Slime_Ice.tres",
		"grade": 2,
		"habitat_type": "snowfield",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 5.0, "int": 7.0, "vit": 5.0}
	},
	"electric_slime": {
		"name": "일렉트릭 슬라임",
		"description": "몸 안에 전류를 머금은 슬라임으로, 가까이 다가온 적에게 순간적인 감전을 일으킨다.",
		"frames_path": "res://Summon_Anim/Slime_Electric.tres",
		"grade": 2,
		"habitat_type": "dark_zone",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 6.0, "int": 7.0, "vit": 4.0}
	},
	"magma_slime": {
		"name": "마그마 슬라임",
		"description": "용암의 열기를 흡수해 변이된 슬라임으로, 느리지만 강한 화염 피해를 입힌다.",
		"frames_path": "res://Summon_Anim/Slime_Magma.tres",
		"grade": 3,
		"habitat_type": "volcano",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 6.0, "agi": 2.0, "int": 4.0, "vit": 9.0}
	},
	"devil_slime": {
		"name": "데빌 슬라임",
		"description": "어둠의 마력에 물든 슬라임으로, 귀여운 외형과 달리 교활한 공격 성향을 보인다.",
		"frames_path": "res://Summon_Anim/Slime_Devil.tres",
		"grade": 3,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 4.0, "agi": 5.0, "int": 9.0, "vit": 5.0}
	},
	"skull_slime": {
		"name": "스컬 슬라임",
		"description": "죽은 생물의 뼈와 마력을 흡수한 슬라임으로, 언데드에 가까운 특성을 지닌다.",
		"frames_path": "res://Summon_Anim/Slime_Skull.tres",
		"grade": 3,
		"habitat_type": "ruins",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 6.0, "int": 3.0, "vit": 6.0}
	},

	# --------------------
	# Beholder
	# --------------------
	"beholder": {
		"name": "비홀더",
		"description": "거대한 눈을 중심으로 마력을 발산하는 기괴한 몬스터로, 다양한 마법 공격을 사용한다.",
		"frames_path": "res://Summon_Anim/Beholder.tres",
		"grade": 3,
		"habitat_type": "dark_zone",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 2.0, "agi": 4.0, "int": 10.0, "vit": 5.0}
	},
	"ancient_beholder": {
		"name": "고대 비홀더",
		"description": "오랜 세월 동안 마력을 축적한 비홀더로, 단순한 몬스터를 넘어선 지성을 지녔다.",
		"frames_path": "res://Summon_Anim/Beholder_Ancient.tres",
		"grade": 4,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 3.0, "agi": 4.0, "int": 12.0, "vit": 7.0}
	},
	"mutant_beholder": {
		"name": "변이 비홀더",
		"description": "불안정한 차원의 마력에 의해 변형된 비홀더로, 예측하기 어려운 공격 패턴을 가진다.",
		"frames_path": "res://Summon_Anim/Beholder_Mutant.tres",
		"grade": 4,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 4.0, "agi": 5.0, "int": 11.0, "vit": 7.0}
	},

	# --------------------
	# Boks
	# --------------------
	"boks": {
		"name": "복스",
		"description": "항상 눈물을 글썽이는 울보 두더쥐. 겁이 많지만 동료를 지키려는 마음은 진심이다.",
		"frames_path": "res://Summon_Anim/Boks.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 4.0, "int": 6.0, "vit": 9.0}
	},

	# --------------------
	# Corel
	# --------------------
	"corel": {
		"name": "코르엘",
		"description": "웰시코기를 닮은 작은 숲의 정령 소환수. 온순하고 주인을 잘 따르며, 숲과 초원 지형에서 특히 활발하게 움직인다.",
		"frames_path": "res://Summon_Anim/Corel.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "supporter",
		"growth_type": "SUP_BUFF",
		"base_stats": {"str": 3.0, "agi": 5.0, "int": 7.0, "vit": 4.0}
	},

	# --------------------
	# Demon
	# --------------------
	"demon": {
		"name": "데몬",
		"description": "화산의 열기와 어둠의 마력을 함께 품은 악마형 몬스터로, 강한 공격성을 보인다.",
		"frames_path": "res://Summon_Anim/Demon.tres",
		"grade": 2,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 5.0, "int": 4.0, "vit": 5.0}
	},
	"blood_demon": {
		"name": "블러드 데몬",
		"description": "피와 분노의 마력으로 강화된 데몬으로, 공격적인 전투에서 높은 위력을 발휘한다.",
		"frames_path": "res://Summon_Anim/Demon_Blood.tres",
		"grade": 3,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 9.0, "agi": 7.0, "int": 3.0, "vit": 6.0}
	},
	"infernion": {
		"name": "인페르논",
		"description": "화산 동굴 깊은 곳에 군림하는 아크데몬. 불길과 파괴의 힘으로 주변을 잿더미로 만든다.",
		"frames_path": "res://Summon_Anim/Demon_Infernion.tres",
		"grade": 4,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 7.0, "agi": 5.0, "int": 12.0, "vit": 8.0}
	},

	# --------------------
	# Ent
	# --------------------
	"ent": {
		"name": "엔트",
		"description": "숲의 마력을 머금고 움직이기 시작한 나무 정령형 몬스터로, 튼튼한 방어력을 가진다.",
		"frames_path": "res://Summon_Anim/Ent.tres",
		"grade": 1,
		"habitat_type": "forest",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 5.0, "agi": 2.0, "int": 3.0, "vit": 8.0}
	},
	"dead_ent": {
		"name": "데드엔트",
		"description": "생명력을 잃고 뒤틀린 엔트로, 부패한 가지를 이용해 적을 압박한다.",
		"frames_path": "res://Summon_Anim/Ent_Dead.tres",
		"grade": 2,
		"habitat_type": "forest",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 6.0, "agi": 2.0, "int": 3.0, "vit": 9.0}
	},
	"elder_ent": {
		"name": "엘더엔트",
		"description": "오랜 세월 숲을 지켜온 고대 엔트로, 강인한 생명력과 자연의 힘을 함께 지녔다.",
		"frames_path": "res://Summon_Anim/Ent_Elder.tres",
		"grade": 3,
		"habitat_type": "forest",
		"role": "tank",
		"growth_type": "TANK_HP",
		"tank_type": "hp",
		"base_stats": {"str": 6.0, "agi": 2.0, "int": 5.0, "vit": 11.0}
	},

	# --------------------
	# Ghost
	# --------------------
	"ghost": {
		"name": "고스트",
		"description": "희미한 영체로 떠도는 몬스터로, 물리적인 실체가 약해 포착하기 어렵다.",
		"frames_path": "res://Summon_Anim/Ghost.tres",
		"grade": 1,
		"habitat_type": "ruins",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 2.0, "agi": 6.0, "int": 6.0, "vit": 3.0}
	},
	"phantom": {
		"name": "팬텀",
		"description": "차가운 마력 속에서 형체를 유지하는 영체형 몬스터로, 적의 공격을 흘려보내듯 움직인다.",
		"frames_path": "res://Summon_Anim/Ghost_Phantom.tres",
		"grade": 2,
		"habitat_type": "snowfield",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 5.0, "agi": 8.0, "int": 4.0, "vit": 4.0}
	},
	"shadow": {
		"name": "섀도우",
		"description": "어둠 속에서 실체를 얻은 그림자 몬스터로, 빠르게 접근해 적의 빈틈을 노린다.",
		"frames_path": "res://Summon_Anim/Ghost_Shadow.tres",
		"grade": 3,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 9.0, "int": 4.0, "vit": 5.0}
	},

	# --------------------
	# Gnoll
	# --------------------
	"gnoll_scout": {
		"name": "놀 정찰병",
		"description": "초원과 황무지를 돌아다니며 사냥감을 찾는 놀로, 빠른 발과 예민한 감각을 지녔다.",
		"frames_path": "res://Summon_Anim/Gnoll_Scout.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 5.0, "agi": 7.0, "int": 2.0, "vit": 4.0}
	},
	"gnoll_warrior": {
		"name": "놀 전사",
		"description": "거친 전투에 단련된 놀로, 정면 전투에서 강한 압박을 가하는 근접형 소환수다.",
		"frames_path": "res://Summon_Anim/Gnoll_Warrior.tres",
		"grade": 2,
		"habitat_type": "desert",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 8.0, "agi": 5.0, "int": 2.0, "vit": 6.0}
	},
	"gnoll_slayer": {
		"name": "놀 학살자",
		"description": "전투 본능이 극단적으로 발달한 놀로, 약한 적을 집요하게 몰아붙이는 잔혹한 개체다.",
		"frames_path": "res://Summon_Anim/Gnoll_Slayer.tres",
		"grade": 3,
		"habitat_type": "desert",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 10.0, "agi": 7.0, "int": 2.0, "vit": 6.0}
	},

	# --------------------
	# Goblin
	# --------------------
	"goblin": {
		"name": "고블린",
		"description": "초원과 숲 가장자리에서 무리를 지어 다니는 작은 몬스터로, 약하지만 수가 많으면 위협적이다.",
		"frames_path": "res://Summon_Anim/Goblin.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 5.0, "agi": 7.0, "int": 2.0, "vit": 3.0}
	},
	"goblin_raider": {
		"name": "고블린 약탈자",
		"description": "약탈에 익숙한 고블린으로, 일반 고블린보다 민첩하고 공격적인 성향을 가진다.",
		"frames_path": "res://Summon_Anim/Goblin_Raider.tres",
		"grade": 2,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 8.0, "int": 2.0, "vit": 4.0}
	},
	"goblin_squadLeader": {
		"name": "고블린 행동대장",
		"description": "고블린 무리를 이끄는 지휘 개체로, 거칠지만 나름의 전술을 사용한다.",
		"frames_path": "res://Summon_Anim/Goblin_SquadLeader.tres",
		"grade": 3,
		"habitat_type": "grassland",
		"role": "supporter",
		"growth_type": "SUP_BUFF",
		"base_stats": {"str": 5.0, "agi": 6.0, "int": 8.0, "vit": 5.0}
	},

	# --------------------
	# Golem
	# --------------------
	"golem": {
		"name": "골렘",
		"description": "흙과 바위에 마력이 깃들어 움직이기 시작한 몬스터로, 느리지만 매우 단단하다.",
		"frames_path": "res://Summon_Anim/Golem.tres",
		"grade": 1,
		"habitat_type": "desert",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 5.0, "agi": 1.0, "int": 2.0, "vit": 9.0}
	},
	"crystal_golem": {
		"name": "보석골렘",
		"description": "보석 광맥의 마력을 흡수한 골렘으로, 일반 골렘보다 높은 내구력과 마력 저항을 가진다.",
		"frames_path": "res://Summon_Anim/Golem_Crystal.tres",
		"grade": 2,
		"habitat_type": "desert",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 5.0, "agi": 1.0, "int": 4.0, "vit": 10.0}
	},
	"varkan": {
		"name": "바르칸",
		"description": "사막 유적을 지키는 고대 골렘 수호자. 육중한 몸체와 압도적인 방어력으로 침입자를 막아선다.",
		"frames_path": "res://Summon_Anim/Golem_Varkan.tres",
		"grade": 4,
		"habitat_type": "desert",
		"role": "tank",
		"growth_type": "TANK_DEF",
		"tank_type": "def",
		"base_stats": {"str": 8.0, "agi": 1.0, "int": 4.0, "vit": 14.0}
	},

	# --------------------
	# Imp
	# --------------------
	"lesser_imp": {
		"name": "꼬마 임프",
		"description": "작고 장난스러운 하급 악마로, 약한 화염 마법과 민첩한 움직임을 사용한다.",
		"frames_path": "res://Summon_Anim/Imp_Lesser.tres",
		"grade": 1,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 3.0, "agi": 6.0, "int": 6.0, "vit": 3.0}
	},
	"imp": {
		"name": "임프",
		"description": "화산 지대에서 자주 발견되는 악마형 몬스터로, 교활한 움직임과 불꽃 공격을 사용한다.",
		"frames_path": "res://Summon_Anim/Imp.tres",
		"grade": 2,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 4.0, "agi": 6.0, "int": 8.0, "vit": 4.0}
	},
	"blood_imp": {
		"name": "블러드 임프",
		"description": "피의 마력에 물든 임프로, 공격할수록 더욱 흉포해지는 성향을 가진다.",
		"frames_path": "res://Summon_Anim/Imp_Blood.tres",
		"grade": 3,
		"habitat_type": "volcano",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 8.0, "agi": 9.0, "int": 3.0, "vit": 5.0}
	},

	# --------------------
	# Lich
	# --------------------
	"lesser_lich": {
		"name": "하급 리치",
		"description": "불완전한 사령술로 죽음을 넘어선 마법사로, 약하지만 위험한 저주 마법을 사용한다.",
		"frames_path": "res://Summon_Anim/Lich_Lesser.tres",
		"grade": 2,
		"habitat_type": "ruins",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 2.0, "agi": 3.0, "int": 9.0, "vit": 4.0}
	},
	"lich_shaman": {
		"name": "리치 주술사",
		"description": "강화된 사령술과 저주 의식을 다루는 리치로, 언데드 계열 소환수와 궁합이 좋다.",
		"frames_path": "res://Summon_Anim/Lich_Shaman.tres",
		"grade": 3,
		"habitat_type": "ruins",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 2.0, "agi": 4.0, "int": 10.0, "vit": 5.0}
	},
	"necros": {
		"name": "네크로스",
		"description": "얼어붙은 성을 지배하는 리치킹. 죽음과 냉기의 마력을 함께 다루는 강력한 군주 개체다.",
		"frames_path": "res://Summon_Anim/Lich_Necros.tres",
		"grade": 4,
		"habitat_type": "snowfield",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 3.0, "agi": 4.0, "int": 13.0, "vit": 7.0}
	},

	# --------------------
	# Lizardman
	# --------------------
	"scout_lizardman": {
		"name": "리자드맨 정찰병",
		"description": "사막과 초원 경계에서 활동하는 리자드맨으로, 빠른 움직임과 창술에 능하다.",
		"frames_path": "res://Summon_Anim/Lizardman_Scout.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 5.0, "agi": 6.0, "int": 2.0, "vit": 5.0}
	},
	"warrior_lizardman": {
		"name": "리자드맨 전사",
		"description": "전투 경험이 풍부한 리자드맨으로, 단단한 비늘과 균형 잡힌 전투 능력을 갖췄다.",
		"frames_path": "res://Summon_Anim/Lizardman_Warrior.tres",
		"grade": 2,
		"habitat_type": "desert",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 6.0, "int": 2.0, "vit": 6.0}
	},
	"commander_lizardman": {
		"name": "리자드맨 사령관",
		"description": "부족을 지휘하는 상위 리자드맨으로, 강한 전투력과 지휘 능력을 함께 지녔다.",
		"frames_path": "res://Summon_Anim/Lizardman_Commander.tres",
		"grade": 3,
		"habitat_type": "desert",
		"role": "supporter",
		"growth_type": "SUP_BUFF",
		"base_stats": {"str": 6.0, "agi": 5.0, "int": 8.0, "vit": 6.0}
	},

	# --------------------
	# Myconid / Mushroom
	# --------------------
	"myconid": {
		"name": "마이코니드",
		"description": "습한 숲속에서 자라난 버섯형 몬스터로, 포자를 이용한 방해 능력에 특화되어 있다.",
		"frames_path": "res://Summon_Anim/Myconid.tres",
		"grade": 1,
		"habitat_type": "forest",
		"role": "supporter",
		"growth_type": "SUP_HEAL",
		"base_stats": {"str": 2.0, "agi": 3.0, "int": 7.0, "vit": 5.0}
	},
	"toxic_myconid": {
		"name": "독성 마이코니드",
		"description": "강한 독포자를 뿜어내는 마이코니드로, 늪지와 오염된 숲에서 주로 발견된다.",
		"frames_path": "res://Summon_Anim/Myconid_Toxic.tres",
		"grade": 2,
		"habitat_type": "swamp",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 2.0, "agi": 4.0, "int": 8.0, "vit": 5.0}
	},
	"hallucinogenic_myconid": {
		"name": "환각 마이코니드",
		"description": "정신을 혼란시키는 포자를 뿌리는 상위 마이코니드로, 전투 흐름을 뒤흔드는 능력을 가진다.",
		"frames_path": "res://Summon_Anim/Myconid_Hallucinogenic.tres",
		"grade": 3,
		"habitat_type": "forest",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 2.0, "agi": 5.0, "int": 10.0, "vit": 5.0}
	},

	# --------------------
	# Nepenthes
	# --------------------
	"carnivorous_nepenthes": {
		"name": "식인 네펜데스",
		"description": "작은 생물을 잡아먹으며 성장한 식물형 몬스터로, 기다렸다가 덮치는 전투 방식에 능하다.",
		"frames_path": "res://Summon_Anim/Nepenthes_Carnivorous.tres",
		"grade": 1,
		"habitat_type": "forest",
		"role": "tank",
		"growth_type": "TANK_HP",
		"tank_type": "hp",
		"base_stats": {"str": 5.0, "agi": 2.0, "int": 3.0, "vit": 8.0}
	},
	"absorbing_nepenthes": {
		"name": "흡수 네펜데스",
		"description": "적의 생명력을 흡수해 자신의 체력을 회복하는 특성을 가진 네펜데스다.",
		"frames_path": "res://Summon_Anim/Nepenthes_Absorbing.tres",
		"grade": 2,
		"habitat_type": "forest",
		"role": "supporter",
		"growth_type": "SUP_HEAL",
		"base_stats": {"str": 3.0, "agi": 3.0, "int": 8.0, "vit": 7.0}
	},
	"venomous_nepenthes": {
		"name": "맹독 네펜데스",
		"description": "치명적인 독액을 품은 상위 네펜데스로, 장기전에 강한 독성 공격을 사용한다.",
		"frames_path": "res://Summon_Anim/Nepenthes_Venomous.tres",
		"grade": 3,
		"habitat_type": "swamp",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 4.0, "agi": 4.0, "int": 10.0, "vit": 7.0}
	},

	# --------------------
	# Orc
	# --------------------
	"orc": {
		"name": "오크",
		"description": "강한 체격과 거친 힘을 가진 몬스터로, 숲과 야영지 주변에서 자주 나타난다.",
		"frames_path": "res://Summon_Anim/Orc.tres",
		"grade": 1,
		"habitat_type": "forest",
		"role": "tank",
		"growth_type": "TANK_HP",
		"tank_type": "hp",
		"base_stats": {"str": 6.0, "agi": 3.0, "int": 2.0, "vit": 8.0}
	},
	"orc_raider": {
		"name": "오크 돌격병",
		"description": "전방 돌파에 특화된 오크로, 방어보다 공격을 우선하는 난폭한 전투 방식을 선호한다.",
		"frames_path": "res://Summon_Anim/Orc_Raider.tres",
		"grade": 2,
		"habitat_type": "forest",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 8.0, "agi": 5.0, "int": 2.0, "vit": 6.0}
	},
	"orc_warlord": {
		"name": "오크 대장군",
		"description": "수많은 전투를 거쳐 살아남은 오크 지휘관으로, 강력한 힘과 위압감을 지닌다.",
		"frames_path": "res://Summon_Anim/Orc_Warlord.tres",
		"grade": 3,
		"habitat_type": "ruins",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 10.0, "agi": 5.0, "int": 3.0, "vit": 8.0}
	},

	# --------------------
	# Ratkin
	# --------------------
	"ratkin": {
		"name": "렛킨",
		"description": "작은 몸집과 빠른 움직임을 가진 쥐인간 몬스터로, 초반 지역에서 자주 발견된다.",
		"frames_path": "res://Summon_Anim/Ratkin.tres",
		"grade": 1,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 4.0, "agi": 8.0, "int": 2.0, "vit": 3.0}
	},
	"mutant_ratkin": {
		"name": "변이 렛킨",
		"description": "불안정한 마력에 노출되어 변이된 렛킨으로, 일반 개체보다 공격성과 생존력이 높다.",
		"frames_path": "res://Summon_Anim/Ratkin_Mutant.tres",
		"grade": 2,
		"habitat_type": "grassland",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 6.0, "agi": 8.0, "int": 3.0, "vit": 5.0}
	},
	"plague_ratkin": {
		"name": "역병 렛킨",
		"description": "늪지의 병독을 품은 렛킨으로, 적에게 지속적인 약화 효과를 유발한다.",
		"frames_path": "res://Summon_Anim/Ratkin_Plague.tres",
		"grade": 3,
		"habitat_type": "swamp",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 7.0, "int": 9.0, "vit": 5.0}
	},

	# --------------------
	# Skeleton
	# --------------------
	"skeleton_soldier": {
		"name": "스켈레톤 병사",
		"description": "오래된 전장의 뼈에 사념이 깃든 언데드로, 기본적인 무기를 다룰 수 있다.",
		"frames_path": "res://Summon_Anim/Skeleton_Soldier.tres",
		"grade": 1,
		"habitat_type": "ruins",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 5.0, "agi": 5.0, "int": 2.0, "vit": 5.0}
	},
	"skeleton_warrior": {
		"name": "스켈레톤 전사",
		"description": "전투 기억이 강하게 남은 스켈레톤으로, 병사 개체보다 훨씬 능숙하게 싸운다.",
		"frames_path": "res://Summon_Anim/Skeleton_Warrior.tres",
		"grade": 2,
		"habitat_type": "ruins",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 6.0, "int": 2.0, "vit": 5.0}
	},
	"skeleton_commander": {
		"name": "스켈레톤 지휘관",
		"description": "언데드 병력을 통솔하는 스켈레톤으로, 냉정한 전투 감각과 지휘 능력을 보인다.",
		"frames_path": "res://Summon_Anim/Skeleton_Commander.tres",
		"grade": 3,
		"habitat_type": "ruins",
		"role": "supporter",
		"growth_type": "SUP_BUFF",
		"base_stats": {"str": 5.0, "agi": 5.0, "int": 8.0, "vit": 6.0}
	},

	# --------------------
	# Vampire
	# --------------------
	"vampire": {
		"name": "뱀파이어",
		"description": "어둠지대에서 활동하는 흡혈 몬스터로, 적의 생명력을 빼앗아 자신의 힘으로 삼는다.",
		"frames_path": "res://Summon_Anim/Vampire.tres",
		"grade": 2,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 7.0, "agi": 7.0, "int": 4.0, "vit": 5.0}
	},
	"vampire_lord": {
		"name": "뱀파이어 로드",
		"description": "하급 뱀파이어를 지배하는 귀족형 몬스터로, 흡혈과 어둠 마법에 모두 능하다.",
		"frames_path": "res://Summon_Anim/Vampire_Lord.tres",
		"grade": 3,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_SK",
		"base_stats": {"str": 6.0, "agi": 6.0, "int": 9.0, "vit": 6.0}
	},
	"alucard": {
		"name": "알루카드",
		"description": "어둠 성채의 최심부에 군림하는 최종 보스. 고귀한 흡혈귀의 힘과 압도적인 어둠의 권능을 지녔다.",
		"frames_path": "res://Summon_Anim/Vampire_Alucard.tres",
		"grade": 4,
		"habitat_type": "dark_zone",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 12.0, "agi": 10.0, "int": 7.0, "vit": 8.0}
	},

	# --------------------
	# Zombie
	# --------------------
	"wandering_zombie": {
		"name": "떠돌이 좀비",
		"description": "목적 없이 늪지와 폐허를 떠도는 언데드로, 느리지만 쉽게 쓰러지지 않는다.",
		"frames_path": "res://Summon_Anim/Zombie_Wandering.tres",
		"grade": 1,
		"habitat_type": "swamp",
		"role": "tank",
		"growth_type": "TANK_HP",
		"tank_type": "hp",
		"base_stats": {"str": 4.0, "agi": 2.0, "int": 2.0, "vit": 9.0}
	},
	"decayed_zombie": {
		"name": "부패 좀비",
		"description": "오랜 시간 부패한 좀비로, 주변에 역한 독기와 질병의 기운을 퍼뜨린다.",
		"frames_path": "res://Summon_Anim/Zombie_Decayed.tres",
		"grade": 2,
		"habitat_type": "swamp",
		"role": "supporter",
		"growth_type": "SUP_DEBUFF",
		"base_stats": {"str": 3.0, "agi": 3.0, "int": 7.0, "vit": 7.0}
	},
	"zombie_warrior": {
		"name": "좀비 전사",
		"description": "생전의 전투 본능이 남아 있는 좀비로, 둔하지만 강한 일격을 가한다.",
		"frames_path": "res://Summon_Anim/Zombie_Warrior.tres",
		"grade": 3,
		"habitat_type": "swamp",
		"role": "attacker",
		"growth_type": "ATK_AS",
		"base_stats": {"str": 9.0, "agi": 3.0, "int": 2.0, "vit": 8.0}
	}
}
