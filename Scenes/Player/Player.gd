extends CharacterBody2D

# Constants
const SPEED = 250.0
const JUMP_VELOCITY = -600.0

# Signals
signal arrow(pos, player1)

# Exports
@export var is_player1: bool = true

# basics
var health = 5
var speed_boost = 00

var shooting: bool = false
var shooting_finish: bool = false
var can_shoot: bool = true
var start_jump: bool = false
var dying: bool = false
var in_lava: bool = false
var dead: bool = false

# Objects
var prev_look_dir: String = ""
var look_dir: String

# Physic
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var lava_gravity = 500

func _ready():
	if is_player1:
		look_dir = "right"
	else:
		look_dir = "left"
	Globals.connect("player_dead", player_dead)

func _physics_process(delta):
	if is_on_floor() && Input.is_action_pressed("shoot" + str(is_player1)) && can_shoot:
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))
		shooting = true
	
	if not is_on_floor():
		velocity.y += gravity * delta - (lava_gravity * delta * int(in_lava))
	
	if !dead && !dying:
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
			if start_jump && prev_look_dir == "":
				prev_look_dir = look_dir
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))

	if !dead:
		move_and_slide()
		anim()

func anim():
	if dying:
		$AnimationPlayer.play("die_" + prev_look_dir)
	elif shooting:
		if is_player1:
			$AnimationPlayer.play("shoot_right")
		else:
			$AnimationPlayer.play("shoot_left")
	elif shooting_finish:
		if is_player1:
			$AnimationPlayer.play("shoot_right_finish")
		else:
			$AnimationPlayer.play("shoot_left_finish")
	elif start_jump:
		$AnimationPlayer.play("start_jump_" + prev_look_dir)
	elif velocity.y < 0:
		$AnimationPlayer.play("jump_" + look_dir)
	elif velocity.y > 0:
		$AnimationPlayer.play("fall_" + look_dir)
	elif is_on_floor():
		if velocity.x != 0:
			$AnimationPlayer.play("run_" + look_dir)
		else:
			$AnimationPlayer.play("idle_" + look_dir)

func shoot():
	can_shoot = false
	$Timers/ArrowCooldown.start()
	if is_player1:
		arrow.emit($ArrowStartPositions/ASPtrue.global_position, true)
	else:
		arrow.emit($ArrowStartPositions/ASPfalse.global_position, false)

func hit():
	if is_player1:
		Globals.health_p1 -= 1
	else:
		Globals.health_p2 -= 1
	$Sprite2D.material.set_shader_parameter("progress", 0.5)
	$Timers/HitShader.start()

func player_dead(is_p1):
	if (is_p1 == is_player1):
		die()

func die():
	dying = true
	if prev_look_dir == "":
		prev_look_dir = look_dir
	velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_jump_left" or anim_name == "start_jump_right":
		start_jump = false
	elif anim_name == "shoot_left" or anim_name == "shoot_right":
		shooting = false
		shooting_finish = true
		shoot()
	elif anim_name== "shoot_left_finish" or anim_name == "shoot_right_finish":
		shooting_finish = false
	elif anim_name== "die_left" or anim_name == "die_right":
		dead = true
		dying = false
		$Sprite2D.frame = 13

func _on_arrow_cooldown_timeout():
	can_shoot = true

func _on_hit_shader_timeout():
	$Sprite2D.material.set_shader_parameter("progress", 0)
