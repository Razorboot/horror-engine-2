extends CharacterBody3D


# Constants
const FRICTION_FACTOR = 20.0


# References
@export var neck: Node3D
@export var camera: Node3D
@export var camera_focus: Node3D
@export var base_speed: float = 1.0
@export var friction: float = 0.7
@export var jump_velocity: float = 4.5

# Variables
var walk_speed: float
var run_speed: float
var crouch_speed: float
var is_moving: bool = false
var is_grounded: bool = false

var smooth_velocity: Vector2 = Vector2.ZERO
var current_speed: float

# Process
func _ready() -> void:
	walk_speed = base_speed * 5.0
	run_speed = base_speed * 7.0
	crouch_speed = base_speed * 3.0
	current_speed = walk_speed

# Move Camera


# Move Character
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		smooth_velocity = smooth_velocity.lerp(Vector2(direction.x * current_speed, direction.z * current_speed),  delta * friction * FRICTION_FACTOR)
	else:
		smooth_velocity = smooth_velocity.lerp(Vector2.ZERO,  delta * friction * FRICTION_FACTOR)
	
	velocity.x = smooth_velocity.x
	velocity.z = smooth_velocity.y
	
	move_and_slide()
