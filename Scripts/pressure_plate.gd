extends Area2D
@export var plate_target: Node2D

func _on_body_entered(body):
	$AnimationPlayer.play("plate_down")
	plate_target.visible = false

func _on_body_exited(body):
	$AnimationPlayer.play("plate_up")
	plate_target.visible = true
