extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var speed_boost = 0
var health = 5

@export var jump: bool
@export var left: bool
@export var right: bool

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump" + str(jump)) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left" + str(jump), "right" + str(jump))
	if direction:
		velocity.x = direction * (SPEED + speed_boost)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))

	move_and_slide()
