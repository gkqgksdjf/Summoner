# ExplainSheet.gd
extends NinePatchRect

@onready var name_label = $NameLabel      # 아이템 이름이 표시될 Label
@onready var desc_label = $DescriptionLabel # 아이템 설명이 표시될 Label
@onready var image_rect = $Image
@onready var trash_button = $TrashButton

func _ready():
	trash_button.visible = false # 처음엔 숨김
	pass

func display(item_data):
	if item_data.is_empty():
		hide_sheet()
		return
		
	name_label.text = item_data["name"]
	desc_label.text = item_data["description"]
	image_rect.texture = InventoryData.get_item_icon(item_data["icon_pos"])
	trash_button.visible = true

func hide_sheet():
	name_label.text = ""
	desc_label.text = ""
	image_rect.texture = null
	trash_button.visible = false
