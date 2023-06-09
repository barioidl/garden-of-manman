extends GOAPAction
class_name ActionEatFood

func _name()->StringName:
	return &'A eat food'

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)

func get_inputs(local_state:Dictionary)->Dictionary:
	if local_state.is_empty():#for baking
		return{NL.has_food:1}
	var root = local_state.root
	var id =get_hotbar_food(root,local_state)
	if id > 0:
		_print('already has food in hotbar')
		return {}
	return{NL.has_food:1}

func get_outputs(local_state:Dictionary)->Dictionary:
	return {
		NL.hunger: -1
	}


func perform(local_state:Dictionary,time:float)-> bool:
	var root = local_state.root
	var id = get_hotbar_food(root,local_state)
	if id <0: return true
	var use_item = root.get_meta(NL.input_use_item)
	use_item.call(id)
	return true

func get_hotbar_food(root,local_state:Dictionary) -> int:
	var get_items = root.get_meta(NL.get_hotbar_items)
	var hotbar_items :Array= get_items.call()
	var foods = local_state[NL.foods]
	for id in hotbar_items.size():
		var food = hotbar_items[id]
		if food == null:
			continue
		var matched := false
		for group in foods:
			if food.is_in_group(group):
				matched = true
		if !matched:
			continue
		return id
	return -1

func _print(line:String):
	return
	print(line)
