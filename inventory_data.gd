extends Node

const ITEM_SHEET1 = preload("res://Resources/Icons.png")
const ITEM_SHEET2 = preload("res://Resources/other_icons.png")
const TILE_SIZE1 = 17
const MAX_SLOTS = 48

var items =[]

enum SheetType {
	ITEM1,
	ITEM2
}

const ITEM_SHEETS = {
	SheetType.ITEM1:ITEM_SHEET1,
	SheetType.ITEM2:ITEM_SHEET2
}

func _ready():
	items.resize(MAX_SLOTS)
	items.fill(null)

# 코인 관리
var coin_db = 0

# 아이템 관리
var item_db = {
	"wood1": {
		"id" = "wood1",
		"name" = "기본 나무",
		"count" = 0,
		"description" = "가장 기본적인 나무.",
		"icon_pos" = Vector2(432, 16),
		"sheet" = SheetType.ITEM1,
	},
	"wood2": {
		"id" = "wood2",
		"name" = "고급 나무",
		"count" = 0,
		"description" = "솜씨 좋은 나무꾼이 정교하게 벤 고급 나무",
		"icon_pos" = Vector2(432, 48),
		"sheet" = SheetType.ITEM1,
	},
	"wood3": {
		"id" = "wood3",
		"name" = "최고급 나무",
		"count" = 0,
		"description" = "품질이 좋은 최고급 나무.",
		"icon_pos" = Vector2(432, 80),
		"sheet" = SheetType.ITEM1,
	},
	"scroll_slime1": {
		"id" = "scroll_slime1",
		"name" = "슬라임 소환서",
		"count" = 0,
		"description" = "슬라임을 소환할 수 있는 소환서",
		"icon_pos" = Vector2(71,7),
		"sheet" = SheetType.ITEM2,
	}
}

func get_item_icon(pos: Vector2, sheet: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ITEM_SHEETS[sheet]
	#atlas.region = Rect2(pos.x * TILE_SIZE1, pos.y * TILE_SIZE1, TILE_SIZE1, TILE_SIZE1)
	atlas.region = Rect2(pos.x, pos.y, TILE_SIZE1, TILE_SIZE1)
	return atlas

func add_item(item_id:String, num:int) -> bool:
	if items.size() > 88:
		print("인벤토리가 가득 찼습니다.")
		return false

	if item_db.has(item_id):
		# 1. 빈 칸(null)을 찾아서 그 위치에 아이템 삽입
		# 1-1. 동일 아이템이 있으면 갯수만 증가
		# 1-2. 동일 아이템보다 null이 먼저 탐색되면 null에 삽입하게되어
		# 동일 아이템이 2칸에 존재하는 이슈 해결을 위한 for문 추가
		for i in range(items.size()):
			if items[i] == null:
				pass
			elif items[i].id == item_id:
				items[i].count += num
				return true
		
		for i in range(items.size()):
			if items[i] != null and items[i].id == item_id:
				items[i].count += num
				return true
			else:
				if items[i] == null:
					var data = item_db[item_id].duplicate()
					data["icon"] = get_item_icon(data["icon_pos"], data["sheet"])
					items[i] = data
					items[i].count += num
					#print(str(i) + "번 슬롯에 아이템 획득: ", data.name)
					return true

		# 2. 루프를 다 돌았는데 null이 없다면 가득 찬 것
		print("인벤토리가 가득 찼습니다.")
		return false
	
	print("존재하지 않는 ID입니다: ", item_id)
	return false
