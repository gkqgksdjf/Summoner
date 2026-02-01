extends LineEdit

var current_selected_slot = null

# 선택된 슬롯
func selected_slot(node):
	current_selected_slot = node

# 입력값 한번 사용시 1로 초기화
func used():
	text = str(1)

# 최소값은 1로 고정
func _on_min_pressed() -> void:
	text = str(1)

# -10개, 기존 입력값이 10보다 작으면 1로 고정
func _on_ten_min_pressed() -> void:
	if int(text) <= 10:
		text = str(1)
	else:
		var num = int(text) - 10
		text = str(num)

# -1개, 기존 입력값이 1보다 작으면 1로 고정
func _on_one_min_pressed() -> void:
	if int(text) <= 1:
		text = str(1)
	else:
		var num = int(text) -1
		text = str(num)

# +1개, 가지고 있는 개수보다 입력값이 커지면 return
func _on_one_plus_pressed() -> void:
	var index = current_selected_slot.get_index()
	if int(text) >= InventoryData.items[index].count:
		return
	else:
		var num = int(text) +1
		text = str(num)

# +10개, 가지고 있는 개수보다 커지면 가지고있는 개수가 최대값
func _on_ten_plus_pressed() -> void:
	var index = current_selected_slot.get_index()
	if int(text) >= InventoryData.items[index].count:
		return
	else:
		var num = int(text) +10
		if num > InventoryData.items[index].count:
			num = InventoryData.items[index].count
		
		text = str(num)

# 최대값은 가지고 있는 개수
func _on_max_pressed() -> void:
	var index = current_selected_slot.get_index()
	
	text = str(InventoryData.items[index].count)
