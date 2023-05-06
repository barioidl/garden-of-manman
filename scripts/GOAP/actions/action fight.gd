extends GOAPAction
class_name ActionFight
func get_name()->StringName:
	return 'fight'

func get_inputs()->Dictionary:
	return{
#		Goap.keys.beep:true,
#		Goap.keys.boop:2
		}
