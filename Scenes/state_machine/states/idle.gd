extends State

@export var fall_state: State
@export var jump_state: State
@export var move_state: State
@export var shoot_state: State
@export var die_state: State

func enter() -> void:
	parent.velocity.x = 0
	var dir: String = "right" if is_p1 else "left"
	
	animations.play("idle_" + dir)

func process_input(event: InputEvent) -> State:
	if get_shoot("shoot" + is_p1_str) and parent.is_on_floor() and parent.can_shoot:
		return shoot_state
	if get_jump("jump" + is_p1_str) and can_jump():
		return jump_state
	if get_movement_input("left" + is_p1_str, "right" + is_p1_str) != 0.0:
		return move_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if dead:
		return die_state
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null

func frame_process(delta: float) -> State:
	if dead:
		return die_state

	animations.play("idle_" + parent.look_dir)
	return null
