extends State

@export var fall_state: State
@export var jump_state: State
@export var idle_state: State
@export var shoot_state: State
@export var die_state: State

func process_physics(delta: float) -> State:
	if get_shoot("shoot" + is_p1_str) and parent.is_on_floor():
		return shoot_state
	
	if get_jump("jump" + is_p1_str) and can_jump():
		return jump_state

	parent.velocity.y += gravity * delta

	var movement = get_movement_input("left" + is_p1_str, "right" + is_p1_str) * move_speed
	set_parent_look_dir(movement)
	
	if movement == 0:
		return idle_state
	
	animations.play("run_" + parent.look_dir)
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null

func process_frame(delta: float) -> State:
	if dead:
		return die_state
	
	return null
