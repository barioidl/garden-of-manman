extends RayCast3D
class_name HotbarUser
@export var hotbar:Node3D

@onready var root:=$'../..'
@onready var input:Inputs=$'../../inputs'
@onready var shape :=$"../../shape"
#@onready var platformer=$'../../platformer'
#var body

func _init() -> void:
	name = 'head'
func _ready() -> void:
	owner = root
	add_exception(root)
	
	get_dependencies()
	set_interface()
	get_head_bone()
	use_shape_size()

func _process(delta: float) -> void:
	copy_bone_position()

func get_dependencies():
	var enable = hotbar != null
#	enabled = enable
	if enable:
		input.connect('drop_pressed',drop_start)
		input.connect('drop_released',drop_stop)
		
		input.connect("act_pressed",act)
		input.connect("attack_pressed",attack)
		input.connect("skill_pressed",skill)
		input.connect("misc_pressed",misc)

func set_interface():
	root.set_meta(NameList.get_target, Callable(get_target))

@export var connect_to_shape:=true
@export var head_margin:=0.2
func use_shape_size():
	if !connect_to_shape: return
	if head_bone != null: return
	shape.connect('on_size_changed',on_size_changed)

func on_size_changed(_size:Vector3):
	position = Vector3(0,_size.y - head_margin,0)

func get_head_bone():
	if !connect_to_bone: return
	head_bone = $"../rig".get_head_bone()

@export var connect_to_bone:=false
var head_bone:Node3D
func copy_bone_position():
	if head_bone == null: return
	var pos = head_bone.global_position
	global_position = pos

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
	if hotbar.hotbar_items.size() < id: return
	var item = hotbar.hotbar_items[id]
	if item == null: 
		default_interact()
		return
	item.use_item(self)
	drop_id = id

func default_interact():
	var body = get_collider()
	if body == null: return
	if !body.has_method(NameList.interact): return
	body.interact(self)

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
	drop_tween.tween_callback(func():drop_tween = null)

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
