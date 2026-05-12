# ExplainSheet.gd
extends NinePatchRect

@onready var name_label = $NameLabel      # 아이템 이름이 표시될 Label
@onready var desc_label = $DescriptionLabel # 아이템 설명이 표시될 Label
@onready var image_rect = $Image
@onready var trash_button = $TrashButton
@onready var use_button = $UseButton
@onready var scroll_button_x1 = $ScrollButton_1
@onready var scroll_button_x10 = $ScrollButton10
@onready var item_count_label = $ItemCount
@onready var coin_count_label = $CoinCount

func _ready():
	trash_button.visible = false # 처음엔 숨김
	coin_count_label.text = str(InventoryData.coin_db)
	pass

func display(item_data):
	if item_data.is_empty():
		hide_sheet()
		return
		
	name_label.text = item_data["name"]
	desc_label.text = item_data["description"]
	item_count_label.text = "(소지 갯수: {0})".format([item_data["count"]])
	image_rect.texture = InventoryData.get_item_icon(item_data["icon_pos"], item_data["sheet"])
	trash_button.visible = true
	
	if item_data["sheet"] == InventoryData.SheetType.ITEM2:
		# use버튼은 다른 사용아이템에 적용.
		#use_button.visible = true
		# scroll에는 1개, 10개 사용 버튼을 적용.
		scroll_button_x1.visible = true
		scroll_button_x10.visible = true
	else:
		#use_button.visible = false
		scroll_button_x1.visible = false
		scroll_button_x10.visible = false

func hide_sheet():
	name_label.text = ""
	desc_label.text = ""
	item_count_label.text = ""
	image_rect.texture = null
	trash_button.visible = false
	use_button.visible = false
	scroll_button_x1.visible = false
	scroll_button_x10.visible = false
