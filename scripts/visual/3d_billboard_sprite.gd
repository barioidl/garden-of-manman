@tool
extends Billboard3d
class_name BillboardSprite

func _ready() -> void:
	super._ready()
	if sprites == null:
		print(str(get_path())+' billboard sprite with null sides')
	

@export var sprites:BillboardSides:
	get:
		return sprites
	set(value):
		if sprites == value: return
		sprites = value
		if sprites == null:	return
		sprites.init()
		select(current_side)

func select(side):
	current_side = side
	if sprites == null:
		return
	var sprite = sprites.get_sprite(side)
	if sprite == null: 
		return
	self.texture = sprite
	emit_signal("sprite_changed")
