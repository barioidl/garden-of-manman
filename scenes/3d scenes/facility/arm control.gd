extends Node3D
var rigid_bodies:=Array()
@onready var parent = get_parent()

func _ready() -> void:
	get_rigid_bodies()

var arm_root
func get_rigid_bodies():
	var rb = self
	while true:
#		print(rb.name)
		setup_rigid(rb)
		if rb.get_child_count() <=0:
			break
		var has_rigid:=false
		for child in rb.get_children(true):
			if child is Area3D:
				rb = child
				has_rigid = true
		if !has_rigid:
			break

func setup_rigid(rb):
	if !rb.is_connected('body_entered',body_enter):
		rb.connect('body_entered',body_enter)
#	rb.contact_monitor = true
#	rb.max_contacts_reported = 2
#	rb.gravity_scale = 0.2
#	rb.linear_damp = 1
#	rb.angular_damp = 1
	rb.add_to_group("mechanical_arm")
	rigid_bodies.append(rb)

func setup_joint(joint):
	joint.swing_span = 30
	joint.twist_span = 2000
	joint.softness = 10

func move_rigids(velo):
	for rb in rigid_bodies:
		rb.linear_velocity = velo

func body_enter(body):
	if body is RigidBody3D:
		parent.detected(body)
#	elif body is CharacterBody3D:
#		parent.detected(body)
