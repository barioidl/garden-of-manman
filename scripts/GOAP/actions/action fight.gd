extends GOAPAction
class_name ActionFight

func name()->StringName:
	return 'action fight'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
#		Goap.keys.beep:true,
#		Goap.keys.boop:2
		}
