extends GOAPAction
class_name ActionFindFood
func get_name()->StringName:
	return 'find food'

func get_inputs()->Dictionary:
	return{
#		Goap.keys.beep:true,
#		Goap.keys.boop:2
		}
