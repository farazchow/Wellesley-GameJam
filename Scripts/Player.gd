extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -100.0
@export var gravity = 200.0

@onready var raycast_line = Line2D.new()

func _ready():
	raycast_line.set_width(1.0)
	add_child(raycast_line)

func _physics_process(delta):
	velocity.y += gravity * delta
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * SPEED
	
	# Mouse Follow
	var local_mouse_pos = get_local_mouse_position()	
	if local_mouse_pos.x < 0:
		$HollowKnight.flip_h = true
	if local_mouse_pos.x > 0:
		$HollowKnight.flip_h = false
	$MouseParticles.position = local_mouse_pos
	
	# clear raycast_lines	
	if horizontal_input != 0:
		raycast_line.clear_points()
	
	move_and_slide()

func _input(event):
	# on jump
	if event.is_action_pressed("ui_jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
	if event.is_action_pressed("ui_left_mouse"):
		var local_mouse_pos = get_local_mouse_position()
		var global_mouse_pos = get_global_mouse_position()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, position + local_mouse_pos)
		var result = space_state.intersect_ray(query)
		print(global_mouse_pos, position, local_mouse_pos)
		
		raycast_line.clear_points()
		raycast_line.add_point(Vector2(0, 0))
		raycast_line.add_point(local_mouse_pos)
		
