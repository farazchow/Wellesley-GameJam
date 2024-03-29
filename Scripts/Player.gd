extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var gravity = 200.0

func _physics_process(delta):
	velocity.y += gravity * delta
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * SPEED
	
	move_and_slide()
