extends Node2D

var dead = false

func _on_character_body_2d_dead():
	dead = true

func _input(event):
	if dead && event is InputEventKey:
		get_tree().reload_current_scene()
