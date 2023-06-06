extends Node

var states:={}
func get_(key,default = 0):
	return states.get(key,default)
func set_(key,value):
	states[key] = value
func remove_(key):
	states.erase(key)
func reset_():
	states = {}

