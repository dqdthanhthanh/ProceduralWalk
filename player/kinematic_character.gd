class_name KinematicCharacter
extends CharacterBody3D


@export var gravity: float = 98
@export var velocity_damp: float = 6
@export var velocity_change_rate: float = 5
@export var min_velocity: float = 0.5
@export var up: Vector3 = Vector3.UP

var _velocity: Vector3
var static_velocity: Vector3


func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		_handle_collision(get_slide_collision(i), delta)

	apply_gravity(delta)
	apply_dyn_vel_damp(delta)
	
	_manipulate_velocities(delta)
	
	if _velocity.length() < min_velocity:
		_velocity = Vector3.ZERO

	move_character(delta)
	move_character_static(delta)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		_velocity -= up * gravity * delta
	else:
		_velocity.y = max(_velocity.y, 0)

func apply_dyn_vel_damp(delta: float) -> void:
	_velocity -= Vector3(_velocity.x, 0, _velocity.z) * velocity_damp * delta

func move_character(delta: float) -> void:
	if _velocity.length() > 0:
		if _velocity.y > 0:
			set_velocity(_velocity)
			set_up_direction(up)
			move_and_slide()
			_velocity = _velocity
		else:
			set_velocity(_velocity)
			# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `Vector3.DOWN * 2`
			set_up_direction(up)
			move_and_slide()
			_velocity = _velocity

func move_character_static(delta: float) -> void:
	if static_velocity.length() > 0:
		if static_velocity.y > 0:
			set_velocity(static_velocity)
			set_up_direction(up)
			move_and_slide()
		else:
			set_velocity(static_velocity)
			# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `Vector3.DOWN * 2`
			set_up_direction(up)
			move_and_slide()

func apply_impulse(vel: Vector3) -> void:
	_velocity += vel

func _manipulate_velocities(delta: float) -> void:
	pass

func _handle_collision(collision: KinematicCollision3D, delta: float) -> void:
	pass

# bounces character based on its velocity
func bounce(direction: Vector3, absorption: float = 0.17) -> void:
	_velocity = direction * _velocity.length() * absorption
