extends GOAPAction
class_name ActionEatFood

func _name()->StringName:
	return 'A eat food'

func get_inputs(local_state:Dictionary)->Dictionary:
	if local_state.has(NL.root):
		var root = local_state.root
		var id =get_hotbar_food(root)
		if id > 0:
			return {}
	return{NL.has_food:1}

func get_outputs(local_state:Dictionary)->Dictionary:
	return {
		NL.has_food:-1,
		NL.hunger: -1
	}

func perform(local_state:Dictionary,time:float)-> bool:
	var root = local_state.root
	
	var id = get_hotbar_food(root)
	if id <0:
		return true
	
	var use_item = root.get_meta(NL.input_use_item)
	use_item.call(id)
	return true


func get_hotbar_food(root) -> int:
	var get_items = root.get_meta(NL.get_hotbar_items)
	var hotbar_items :Array= get_items.call()
	for id in hotbar_items.size():
		var food = hotbar_items[id]
		if food == null:
			continue
		if !food.is_in_group(NL.food):
			continue
		return id
	return -1
