extends CanvasLayer

@onready var inventory_ui = $InventoryUI

# 밖에서 볼 수 있는 전역 시그널 선언
signal inventory_toggled(is_open: bool)

func _ready():
	# 자식인 InventoryUI의 시그널을 나에게 연결
	$InventoryUI.inventory_toggled.connect(_on_child_inventory_toggled)

func _on_child_inventory_toggled(is_open: bool):
	# 자식이 보낸 신호를 외부로 다시 배포 (중계)
	inventory_toggled.emit(is_open)


func _on_inventory_button_pressed() -> void:
	inventory_ui.toggle()


func _on_scroll_button_1_pressed() -> void:
	pass # Replace with function body.
