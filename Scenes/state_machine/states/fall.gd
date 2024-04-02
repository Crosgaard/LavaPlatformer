extends State

@export var move_state: State
@export var idle_state: State
@export var die_state: State

func enter() -> void:
	var dir: String = "right" if is_p1 else "left"
	animations.play("fall_" + dir)

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
		
		if movement != 0:
			return move_state
		return idle_state
	return null

func process_frame(delta: float) -> State:
	if dead:
		return die_state
	
	return null
