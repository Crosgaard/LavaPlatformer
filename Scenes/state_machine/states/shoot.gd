extends State

@export var jump_state: State
@export var idle_state: State
@export var shoot_state: State
@export var die_state: State

var shooting: bool = false
var finish_shooting: bool = false

func enter() -> void:
	parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)
	shooting = true

func process_frame(delta: float) -> State:
	if dead:
		return die_state
	
	if shooting:
		if is_p1:
			animations.play("shoot_right")
		else:
			animations.play("shoot_left")
	elif finish_shooting:
		if is_p1:
			animations.play("shoot_right_finish")
		else:
			animations.play("shoot_left_finish")
	else:
		if parent.rapid_fire:
			if parent.rapid_fire_current < parent.rapid_fire_max - 1:
				parent.rapid_fire_current += 1
				return shoot_state
			else:
				parent.rapid_fire = false
				parent.rapid_fire_current = 0
		parent.shoot_cooldown.start()
		
		return idle_state
	return null

func shoot() -> void:
	parent.arrow.emit(parent.arrow_pos, is_p1, parent.power)
	
	shooting = false
	finish_shooting = true
	
	if parent.power:
		parent.power = false

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "shoot_right" or anim_name == "shoot_left":
		shooting = false
		shoot()
		
	
	elif anim_name == "shoot_right_finish" or anim_name == "shoot_left_finish":
		finish_shooting = false
