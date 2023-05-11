extends CharacterBody3D
class_name ItemOverworld

var item:Resource

var root:RigidCharacter
var id :=-1
var is_in_overworld:=true

@export var interact_range:=2.0
signal item_equipped
signal item_unequipped
signal item_used

func equip_item(_root,_id:=-1):
	emit_signal('item_equipped')
	root = _root
	id=_id
	is_in_overworld = false
	add_collision_exception_with(root)

func unequip_item():
	emit_signal('item_unequipped')
	var tween = create_tween()
	tween.tween_interval(0.2)
	tween.tween_callback(reset_exception.bind(root))
	root = null
	id = -1
	is_in_overworld = true

func reset_exception(_root):
	remove_collision_exception_with(_root)

func use_item(head:HotbarUser)->bool:
	emit_signal('item_used')
	var body = head.get_target()
	if body == null: return false
	var point = head.get_contact()
	var dist = global_position.distance_squared_to(point)
	if dist > interact_range*interact_range: 
		return false
	if !body.has_method(NameList.interact): 
		return false
	body.interact(self)
	return true

func interact(user):
	user = user.root
	if user == null:return
	var append_item_node = user.get_meta(NameList.append_item_node)
	if append_item_node == null:return
	var added = append_item_node.call(self)

var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var time :=0.0
func _physics_process(delta: float) -> void:
	if !is_in_overworld: return
	
	var on_floor = is_on_floor()
	if !on_floor:
		velocity += gravity * delta
	
	if velocity != Vector3.ZERO:
		var friction = 5*delta if on_floor else delta
		velocity = velocity.lerp(Vector3.ZERO,friction)
		move_and_slide()
	else:
		time -= delta
		if time <0:
			time = 1
			move_and_slide()

func toggle_physics(is_overworld):
	for shape in get_children():
		if not shape is CollisionShape3D: continue
		shape.disabled = !is_overworld
