extends State

@export var jump_buffer: float = 0.1
@export var move_state: State
@export var idle_state: State
@export var die_state: State
@export var jump_state: State

var jump_buffer_timer: float = 0.0

func enter() -> void:
	var dir: String = "right" if is_p1 else "left"
	animations.play("fall_" + dir)
	jump_buffer_timer = 0.0

func input(event: InputEvent) -> State:
	if get_jump("jump" + is_p1_str): 
		if can_jump():
			return jump_state
		else:
			jump_buffer_timer = jump_buffer
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_input("left" + is_p1_str, "right" + is_p1_str) * move_speed
	
	set_parent_look_dir(movement)
	
	if movement != 0:
		animations.play("fall_" + parent.look_dir)

	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.jump_count = 0
		
		if jump_buffer_timer > 0:
			return jump_state
		if movement != 0:
			return move_state
		return idle_state
	return null

func process_frame(delta: float) -> State:
	if dead:
		return die_state
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	return null
