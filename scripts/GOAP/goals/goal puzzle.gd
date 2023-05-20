extends GOAPGoal
class_name GoalPuzzle

func name() -> StringName:
	return 'G puzzle'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.jumpscare)

func priority(local_state:Dictionary)-> float:
	var jumpscare = local_state[NL.jumpscare]
	var score = jumpscare.puzzle_score
	return Curves.sample(5,4,score)

func get_result(local_state:Dictionary)->Dictionary:
	return{
#		NL.player_fear:1
	}
