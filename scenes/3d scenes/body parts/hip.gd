extends Marker3D

@onready var root = get_parent().root
@onready var platformer = $"../../../platformer"

@export var legs_per_steps:=1
var current_leg:=-1
var total_legs:=0

@export var leg_paths:Array[NodePath]=[]
var leg_nodes:=[]

func _ready() -> void:
	setup_legs()
	platformer.connect(NameList.on_state_changed, on_state_changed)

#var time:=0.0
#func _physics_process(delta: float) -> void:
#	time = delta

func setup_legs():
	for path in leg_paths:
		var leg = get_node_or_null(path)
		if leg == null: 
			continue
		leg_nodes.append(leg)
	total_legs = leg_nodes.size()
	leg_paths=[]

func on_state_changed(state:StringName):
	match state:
		NameList.walk:
			walk()
		NameList.sneak:
			sneak()
		NameList.sprint:
			sprint()
		NameList.jump:
			jump()
		NameList.fall:
			fall()

func walk():
	var duration = step_duration
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()
	loop_tween.tween_interval(duration)
	loop_tween.tween_callback(walk)
	foot_step(NameList.walk, duration)

func sneak():
	var duration = step_duration*1.25
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()
	loop_tween.tween_interval(duration)
	loop_tween.tween_callback(sneak)
	foot_step(NameList.sneak, duration)
	
func sprint():
	var duration = step_duration*0.75
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()
	loop_tween.tween_interval(duration)
	loop_tween.tween_callback(sprint)
	foot_step(NameList.sprint, duration)

func jump():
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()

func fall():
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()

@export var step_duration :=0.2
@onready var loop_tween :=create_tween()

func foot_step(_state:StringName, duration:float):
	var leg_moved:=0
	for i in legs_per_steps:
		current_leg = wrapi(current_leg+1,0,total_legs)
		var leg = leg_nodes[current_leg]
		if leg.play_state(_state, duration):
			leg_moved += 1
	
	if leg_moved >0:
		move_hip(step_duration)

func move_hip(duration:float):
	duration *= 0.5
	var mid :=Vector3(0,0,0)
	var end :=Vector3(0,-0.05,0)
	var tween = create_tween()
	tween.tween_property(self,'position',mid,duration)
	tween.tween_property(self,'position',end,duration)
