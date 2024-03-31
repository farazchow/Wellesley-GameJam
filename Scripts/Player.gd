extends CharacterBody2D

#signals
signal dead

# variables
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -100.0
@export var gravity = 200.0
@export var air_force = -300.0
var double_jump_able = false
var element = 0

# instantiating assets
@onready var raycast_line = Line2D.new()
var mouse_particles = preload("res://Scenes/mouse_particles.tscn")
var mouse_particles_instance

# Elements [Air, Water, Earth, Fire]
const particle_colors = ["#FFFFFF", "#1E88E5", "#8D6E63", "#C62828"]

func _ready():
	raycast_line.set_width(1.0)
	add_child(raycast_line)
	
	mouse_particles_instance = mouse_particles.instantiate()
	mouse_particles_instance.process_material.color = Color(particle_colors[0])
	add_child(mouse_particles_instance)

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
	mouse_particles_instance.position = local_mouse_pos
	
	# clear raycast_lines	
	if horizontal_input != 0:
		raycast_line.clear_points()
	
	move_and_slide()

func _input(event):
	# on jump
	if event.is_action_pressed("ui_jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
		double_jump_able = true
	elif event.is_action_pressed("ui_jump") && double_jump_able:
		double_jump_able = false
		velocity.y = JUMP_VELOCITY
		
	if event.is_action_pressed("ui_left_mouse"):
		var local_mouse_pos = get_local_mouse_position()
		var global_mouse_pos = get_global_mouse_position()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_mouse_pos)
		query.exclude = [self]
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		# Air
		if element == 0:
			if not result.is_empty() and result["collider"].get_class() == "RigidBody2D":
				result["collider"].apply_central_impulse(result["normal"] * air_force)
		# Water
		if element == 1:
			if not result.is_empty() and result["collider"].is_in_group("Water"):
				result["collider"].freeze()
		
		raycast_line.clear_points()
		raycast_line.add_point(Vector2(0, 0))
		if not result.is_empty():
			raycast_line.add_point(raycast_line.to_local(result["position"]))
		else: 
			raycast_line.add_point(local_mouse_pos)
	
	# Change Element
	if event.is_action_pressed("ui_right_mouse"):
		element = (element+1) % 4
		mouse_particles_instance.process_material.color = Color(particle_colors[element])

func die():
	dead.emit()
	queue_free()
