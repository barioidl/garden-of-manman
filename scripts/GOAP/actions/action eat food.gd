extends GOAPAction
class_name ActionEatFood
func get_name()->StringName:
	return 'eat food'

func get_inputs()->Dictionary:
	return{
#		Goap.keys.beep:true,
#		Goap.keys.boop:2
		}
func get_outputs()->Dictionary:
	return {
		Goap.keys.is_hungry: 0
	}
