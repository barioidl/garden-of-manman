extends RayCast3D
class_name HotbarUser
@export var hotbar:Node3D

@onready var root:=$'../..'
@onready var input:Inputs=$'../../inputs'
@onready var platformer=$'../../platformer'
#var body
func _init() -> void:
	name = 'head'
func _ready() -> void:
	owner = root
	add_exception(root)
	add_to_group('has_root')
	get_dependencies()

func get_dependencies():
	if hotbar != null:
		print('connect hotbar')
		input.connect('drop_pressed',drop_start)
		input.connect('drop_released',drop_stop)
		
		input.connect("act_pressed",act)
		input.connect("attack_pressed",attack)
		input.connect("skill_pressed",skill)
		input.connect("misc_pressed",misc)
	
#	root.set_meta('get_target',Callable(get_target))
#	root.set_meta('set_target',Callable(set_target))
	
	platformer.connect("on_state_changed", on_state_changed.bind())

@export var normal_height:= 2.0
@export var crouch_height:= 1.4
func on_state_changed(state):
	var tween = get_tree().create_tween()
	var is_sneaking = state == platformer.states.sneak
	var height = crouch_height if is_sneaking else normal_height
	tween.tween_property(self,'position', Vector3(0,height,0),0.1).set_trans(Tween.TRANS_SINE)

func get_target()->PhysicsBody3D:
	return get_collider()

func get_contact()->Vector3:
	if is_colliding():
		return get_collision_point()
	return to_global(target_position)

func act():
	var body = get_target()
	if body == null: 	return
	if !body.has_method("interact"): 	return
	body.interact(self)

func attack():
	use_item(0)

func skill():
	use_item(1)

func misc():
	use_item(2)

func use_item(id:int):
	print('use item')
	if hotbar.hotbar_items.size() < id: return
	var item = hotbar.hotbar_items[id]
	if item == null: 
		hotbar.hands[id].use_item(self)
		return
	item.use_item(self)
	drop_id = id

var drop_id:=-1
var drop_strength:=0.0:
	get:
		return drop_strength
	set(value):
		if drop_strength == value:return
		drop_strength = value
		emit_signal('drop_updated',value)
signal drop_updated(value)
var drop_tween:Tween
func drop_start():
	drop_strength = 0
	drop_tween = create_tween()
	drop_tween.tween_property(self,'drop_strength',1,1.0)
	drop_tween.tween_callback(drop_item)

func drop_stop():
	if drop_tween == null:return
	drop_tween.kill()
	drop_item()

func drop_item():
	if drop_id <0: return
	if drop_strength <0: return
	var aim_at = to_global(Vector3(0,0,10))
	hotbar.drop_item(drop_id,aim_at,drop_strength)
	drop_strength = 0
