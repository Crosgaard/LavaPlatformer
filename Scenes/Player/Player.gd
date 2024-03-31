extends CharacterBody2D

# Constants
const SPEED = 250.0
const JUMP_VELOCITY = -600.0

# Signals
signal arrow(pos, player1, power)
signal player_has_died(is_p1)

# Exports
@export var is_player1: bool = true

# basics
var health = 5
var speed_boost = 0
var jump_count: int = 0
var max_jump_count: int = 1
var jump_timer: bool = false:
	set(value):
		jump_timer = value
		if value:
			$Timers/JumpCooldown.start()

var shooting: bool = false
var shooting_finish: bool = false
var can_shoot: bool = true
var start_jump: bool = false
var dying: bool = false
var in_lava: bool = false
var dead: bool = false

# Power-ups
var power: bool = false
var shield: bool = false:
	set(value):
		shield = value
		if value:
			set_shield_shader()
		else:
			reset_shader()

var double_jump: bool = false:
	set(value):
		double_jump = value
		if value:
			max_jump_count = 2
			$Timers/DoubleJumpStop.start()
			set_dj_shader()
		else:
			max_jump_count = 1
			if !shield:
				reset_shader()
			else:
				set_shield_shader()

var rapid_fire: bool = false
var rapid_fire_max: int = 3
var rapid_fire_current: int = 0

# Objects
var prev_look_dir: String = ""
var look_dir: String
var prev_collisions: Array

# Physic
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var lava_gravity = 500

func _ready():
	if is_player1:
		look_dir = "right"
	else:
		look_dir = "left"
	Globals.connect("player_dead", player_dead)
	Globals.connect("shield_change", update_shield)
	$Sprite2D.material.set_shader_parameter("progress", 0.0)

func _physics_process(delta):
	if is_on_floor() && Input.is_action_pressed("shoot" + str(is_player1)) && can_shoot:
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))
		shooting = true
	
	if not is_on_floor():
		velocity.y += gravity * delta - (lava_gravity * delta * int(in_lava))
	else:
		jump_count = 0
	
	if !dead && !dying:
		if Input.is_action_pressed("jump" + str(is_player1)) and (jump_count < max_jump_count) and not jump_timer and not shooting:
			velocity.y = JUMP_VELOCITY
			start_jump = true
			jump_count += 1
			print("Jump count: " + str(jump_count))
			print("Max jump count: " + str(max_jump_count))
			if prev_look_dir == "":
				prev_look_dir = look_dir
			jump_timer = true

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

# Animations
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
		player_has_died.emit(is_player1)


# Shooting
func shoot():
	can_shoot = false
	$Timers/ArrowCooldown.start()
	if is_player1:
		arrow.emit($ArrowStartPositions/ASPtrue.global_position, is_player1, power)
	else:
		arrow.emit($ArrowStartPositions/ASPfalse.global_position, is_player1, power)
	
	if power:
		power = false
	
	if rapid_fire:
		if rapid_fire_current < rapid_fire_max - 1:
			shooting = true
			rapid_fire_current += 1
		else:
			rapid_fire = false
			rapid_fire_current = 0

func hit(dmg):
	if !shield:
		if is_player1:
			Globals.health_p1 -= dmg
		else:
			Globals.health_p2 -= dmg
		$Sprite2D.material.set_shader_parameter("progress", 0.5)
		$Sprite2D.material.set_shader_parameter("color", Vector4(1,0,0,1))
		$Timers/HitShader.start()
	else:
		if is_player1:
			Globals.shield_p1 = false
		else:
			Globals.shield_p2 = false


# Dying
func player_dead(is_p1):
	if (is_p1 == is_player1):
		die()

func die():
	dying = true
	if prev_look_dir == "":
		prev_look_dir = look_dir
	velocity.x = move_toward(velocity.x, 0, (SPEED + speed_boost))


# Shield
func update_shield(is_p1):
	if is_p1 && is_player1:
		shield = Globals.shield_p1
	elif not is_p1 and not is_player1:
		shield = Globals.shield_p2

func set_shield_shader():
	$Sprite2D.material.set_shader_parameter("color", Vector3(0,0,0.5))
	$Sprite2D.material.set_shader_parameter("progress", 0.3)

func set_dj_shader():
	$Sprite2D.material.set_shader_parameter("progress", 0.5)
	$Sprite2D.material.set_shader_parameter("color", Vector4(0.3,1,0.3,1))

func reset_shader():
	$Sprite2D.material.set_shader_parameter("progress", 0)


# Timers
func _on_arrow_cooldown_timeout():
	can_shoot = true

func _on_hit_shader_timeout():
	reset_shader()

func _on_double_jump_stop_timeout():
	double_jump = false

func _on_jump_cooldown_timeout():
	jump_timer = false
