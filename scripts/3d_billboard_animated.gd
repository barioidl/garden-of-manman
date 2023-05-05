extends Node
@export var sun_face:Node3D
@export var moon_face:Node3D

@onready var parent :=$".."
@export var lamp :OmniLight3D
@export var switch_sfx:AudioList
func _ready() -> void:
	switch(false)
func switch(is_sun):
	var pos = parent.global_position
	AudioPool.create_sound_3d(pos,switch_sfx)
	
	sun_face.visible = is_sun
	moon_face.visible = !is_sun
	
	lamp.light_energy = 1 if is_sun else 0.1
