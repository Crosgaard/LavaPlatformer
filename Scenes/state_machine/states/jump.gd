extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State
@export var shoot_state: State
@export var die_state: State

@export var jump_force: float = 600.0

var start_jump: bool = false

func enter() -> void:
	start_jump = true
	parent.jump_count += 1
	parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if dead:
		return die_state
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = get_movement_input("left" + is_p1_str, "right" + is_p1_str) * move_speed
	if not start_jump:
		set_parent_look_dir(movement)
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if start_jump:
		animations.play("start_jump_" + parent.prev_look_dir)
	else:
		animations.play("jump_" + parent.look_dir)
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null

func process_frame(delta: float) -> State:
	if dead:
		return die_state
	
	return null

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "start_jump_" + parent.prev_look_dir:
		start_jump = false
