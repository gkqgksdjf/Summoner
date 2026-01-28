extends Node

const ITEM_SHEET1 = preload("res://Resources/Icons.png")
const TILE_SIZE1 = 16
const MAX_SLOTS = 88

var items =[]

func _ready():
	items.resize(MAX_SLOTS)
	items.fill(null)

var item_db = {
	"wood1": {
		"name" = "기본 나무",
		"description" = "가장 기본적인 나무.",
		"icon_pos" = Vector2(432, 16)
	},
	"wood2": {
		"name" = "고급 나무",
		"description" = "솜씨 좋은 나무꾼이 정교하게 벤 고급 나무.",
		"icon_pos" = Vector2(432, 48)
	},
	"wood3": {
		"name" = "최고급 나무",
		"description" = "품질이 좋은 최고급 나무.",
		"icon_pos" = Vector2(432, 80)
	}
}

func get_item_icon(pos: Vector2) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ITEM_SHEET1
	#atlas.region = Rect2(pos.x * TILE_SIZE1, pos.y * TILE_SIZE1, TILE_SIZE1, TILE_SIZE1)
	atlas.region = Rect2(pos.x, pos.y, TILE_SIZE1, TILE_SIZE1)
	return atlas

func add_item(item_id:String) -> bool:
	if items.size() > 88:
		print("인벤토리가 가득 찼습니다.")
		return false

	if item_db.has(item_id):
		var data = item_db[item_id].duplicate()
		data["icon"] = get_item_icon(data["icon_pos"])

		# 1. 빈 칸(null)을 찾아서 그 위치에 아이템 삽입
		for i in range(items.size()):
			if items[i] == null:
				items[i] = data
				#print(str(i) + "번 슬롯에 아이템 획득: ", data.name)
				return true

		# 2. 루프를 다 돌았는데 null이 없다면 가득 찬 것
		print("인벤토리가 가득 찼습니다.")
		return false
	
	print("존재하지 않는 ID입니다: ", item_id)
	return false
