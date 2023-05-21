extends GOAPGoal
class_name GoalJumpscare

func name() -> StringName:
	return 'G jumpscare'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.jumpscare)

func priority(local_state:Dictionary)-> float:
	var jumpscare = local_state[NL.jumpscare]
	var score = jumpscare.score
	return Curves.sample(5,1,score)

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.player_fear:1
	}
