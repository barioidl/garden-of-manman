extends Node
@export var sun_face:BillboardSides
@export var moon_face:BillboardSides

@onready var face :=$".."
@onready var lamp := $"../OmniLight3D"
@export var switch_sfx:AudioList
func _ready() -> void:
	switch(false)
func switch(is_sun):
	var pos = face.global_position
	AudioPool.create_sound_3d(pos,switch_sfx)
	
	if is_sun:
		face.set("sprites",sun_face)
		lamp.light_energy = 1
	else:
		face.set("sprites",moon_face)
		lamp.light_energy = 0.1
