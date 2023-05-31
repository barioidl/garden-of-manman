extends Node

var planner_action = GOAPPlanner.new()
#var planner_dialogue
#var planner_music
#var planner_tutorial
#var planner_animation
#var planner_items

func _ready() -> void:
	add_to_group(NL.on_quit)
	load_all_data()
	init_action_planner()

func on_quit():
	
	save_all_data()

func init_action_planner():
	var planner_actions := [
#		ActionTakeFoodFromItem.new(),
#		ActionFindFood.new(),
#		ActionEatFood.new(),
		
#		ActionFindKey.new(),
#		ActionOpenDoor.new(),
#		ActionScream.new(),
#		ActionFaceTarget.new(),
#		ActionAttackTarget.new(),
#		ActionPuzzle.new(),
		
	]
	for action in planner_actions:
		action._load()
	planner_action.actions = planner_actions

func get_action_planner()->GOAPPlanner:
	return planner_action


var mutation_amount:=0.01
var all_mutations := {}
var mutations_path := "user://mutations.json"
func save_mutations(data:Dictionary):
	var data_name = data.name
	if !all_mutations.has(data_name):
		all_mutations[data_name] = data
		_print('accepted new mutation')
		return
	if data.score <= 0:
		_print('rejected weak mutation')
		return
	var current_data = all_mutations[data_name]
	if current_data.score > data.score:
		_print('rejected disadvantaged mutation')
		return
	all_mutations[data_name] = data

func load_mutations(name:StringName)->Dictionary:
	if !all_mutations.has(name):
		_print('load failed, return empty mutation')
		return {}
	all_mutations[name].score *= 0.5
	
	var weights = all_mutations[name].weights
	for key in weights.keys():
		var delta = randf_range(-1,1) * mutation_amount
		weights[key] = clampf(weights[key]+delta,0,1)
	
	return all_mutations[name]



func save_all_data():
	var nodes = get_tree().get_nodes_in_group(NL.goap_save_load)
	for i in nodes:
		i._save()
	for action in planner_action.actions:
		action._save()
	_save(all_mutations.values(), mutations_path)

func load_all_data():
	all_mutations = _load(mutations_path)


var disable_when_debug := false
func _save(resources:Array, path:String):
	if disable_when_debug:
		if OS.is_debug_build():
			return
	var save_game = FileAccess.open(path, FileAccess.WRITE)
	for data in resources:
		var json_string = JSON.stringify(data)
		save_game.store_line(json_string)
	
func _load(path:String) -> Dictionary:
	if disable_when_debug:
		if OS.is_debug_build():
			return {}
	if !FileAccess.file_exists(path):
		return {}
	var output:={}
	var save_game = FileAccess.open(path, FileAccess.READ)
	var data_length := save_game.get_length()
	while save_game.get_position() < data_length:
		var json_string = save_game.get_line()
		
		var json = JSON.new()
		var error = json.parse(json_string)
		if error != OK:
			_print("JSON Parse Error: " + str(json.get_error_line()))
			continue
		var data = json.get_data()
		if data == null:
			_print('data is null')
			continue
		if !data.has('name'):
			_print('wrong data structure')
			continue
		output[data.name] = data
	return output

func _print(line:String):
	return
	print(line)
