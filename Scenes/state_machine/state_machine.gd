extends Node

@export var starting_state: State

var current_state: State

func init(
		parent: CharacterBody2D, 
		animations: AnimationPlayer, 
		move_component, 
		is_p1: bool, 
		player_dead_con: String,
		) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
		child.move_component = move_component
		child.is_p1 = is_p1
		child.player_dead_con = player_dead_con

	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func on_animation_finished(anim_name: String) -> void:
	current_state.on_animation_finished(anim_name)
