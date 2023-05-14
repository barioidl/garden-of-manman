extends GOAPAction
class_name ActionEatFood
func name()->StringName:
	return 'A eat food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:1,
		}
func get_outputs(self_state:Dictionary)->Dictionary:
	return {
		NameList.has_food:-1,
		NameList.hunger: -1
	}

func perform(agent: GOAPAgent, local_state:Dictionary,time:float)-> bool:
	var root = agent.root
	
	var id =get_hotbar_food(root)
	if id <0:
		return true
	
	var use_item = root.get_meta(NameList.input_use_item)
	use_item.call(id)
	
	if local_state.has(NameList.food):
		local_state.erase(NameList.food)
	return true


func get_hotbar_food(root) -> int:
	var get_items = root.get_meta(NameList.get_hotbar_items)
	var hotbar_items :Array= get_items.call()
	for id in hotbar_items.size():
		var food = hotbar_items[id]
		if !food.is_in_group(NameList.food):
			continue
		return id
	return -1
