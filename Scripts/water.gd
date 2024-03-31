extends Area2D

@export var frozen_time = 1
var frozen = false

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	if not frozen:
		body.die()

func freeze():
	if not frozen:
		frozen = true
		$IceBody.visible = true
		$Timer.start(frozen_time)
		$IceBody.set_collision_layer_value(1, true)

func _on_timer_timeout():
	frozen = false
	$IceBody.visible = false
	$IceBody.set_collision_layer_value(1, false)
