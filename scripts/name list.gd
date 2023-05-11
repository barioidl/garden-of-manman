@tool
extends Node

func list_of_states():pass
var die := &'die'
var walk:= &'walk'
var sneak := &'sneak'
var sprint := &'sprint'
var jump := &'jump'
var fall := &'fall'

func list_of_goap_states():pass
var creativity := &'creativity'
var curiosity := &'curiosity'
var integrity := &'integrity'
var compassion := &'compassion'
var efficient := &'efficient'
var ambitious := &'ambitious'
var honesty := &'honesty'
var bravery := &'bravery'

var plan_width := &'plan_width'
var plan_depth := &'plan_depth'

var has_food := &'has_food'
var has_drink := &'has_drink'
var has_key := &'has_key'

var hunger := &'hunger'
var max_hunger := &'max_hunger'

var health := &'health'
var max_health := &'max_health'

var mana := &'mana'
var max_mana := &'max_mana'


func list_of_group_names():pass
var food := &'food'
var drink := &'drink'
var healing_item := &'healing_item'
var key := &'key'
var character := &'character'
var ui_save_load := &'ui_save_load'
var billboard_sprites:= &'billboard_sprites'

func list_of_meta():pass
var show_dialogue:= &'show_dialogue'
var show_image:= &'show_image'
var connect_stats_display := &'connect_stats_display'

var get_inputs := &'get_inputs'
var delay_platformer := &'delay_platformer'
var get_target := &'get_target'
var turn_head_toward:= &'turn_head_toward' 

var send_message:= &'send_message'
var receive_message:= &'receive_message'

var respawn := &'respawn'

var append_item:=&'append_item'
var append_item_node:=&'append_item_node'
var get_hotbar_items:=&'get_hotbar_items'


func list_of_methods():pass
var interact:=&'interact'

func list_of_signals():pass
var health_updated:= &'health_updated'
var mana_updated:= &'mana_updated'
var hunger_updated:= &'hunger_updated'
var on_state_changed := &'on_state_changed'
