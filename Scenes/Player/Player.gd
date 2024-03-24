extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -1050.0

var speed_boost = 0
var health = 5
var start_jump: bool = false
var start_jump_look_dir: String = ""
var shooting: bool = false

@export var is_player1: bool = true

var look_dir: String
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if is_player1:
		look_dir = "right"
	else:
		look_dir = "left"

func _physics_process(delta):
	if is_on_floor() && Input.is_action_pressed("shoot" + str(is_player1)):
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))
		shooting = true
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump" + str(is_player1)) and is_on_floor() and !shooting:
		velocity.y = JUMP_VELOCITY
		start_jump = true

	var direction = Input.get_axis("left" + str(is_player1), "right" + str(is_player1))
	if direction && !shooting:
		velocity.x = direction * (SPEED + speed_boost)
		if direction < 0:
			look_dir = "left"
		else:
			look_dir = "right"
		if start_jump && start_jump_look_dir == "":
			start_jump_look_dir = look_dir
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))

	move_and_slide()
	anim()

func anim():
	if shooting:
		if is_player1:
			$AnimationPlayer.play("shoot_right")
		else:
			$AnimationPlayer.play("shoot_left")
	elif start_jump:
		$AnimationPlayer.play("start_jump_" + start_jump_look_dir)
	elif velocity.y < 0:
		$AnimationPlayer.play("jump_" + look_dir)
	elif velocity.y > 0:
		$AnimationPlayer.play("fall_" + look_dir)
	elif is_on_floor():
		if velocity.x != 0:
			$AnimationPlayer.play("run_" + look_dir)
		else:
			$AnimationPlayer.play("idle_" + look_dir)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_jump_left" or anim_name == "start_jump_right":
		start_jump = false
	if anim_name == "shoot_left" or anim_name == "shoot_right":
		shooting = false
		shoot()

func shoot():
	pass
