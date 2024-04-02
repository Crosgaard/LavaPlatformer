class_name State
extends Node

@export var animation_name: String

@export var move_speed: float = 250.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var animations: AnimationPlayer
var move_component
var parent: CharacterBody2D
var is_p1: bool
var dead: bool
var player_dead_con: String

@onready var is_p1_str: String = str(is_p1)

func ready() -> void:
	Globals.connect(player_dead_con, player_dead)

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func on_animation_finished(anim_name: String) -> void:
	pass

func player_dead():
	dead = true

func set_parent_look_dir(movement: float) -> void:
	parent.look_dir = "left" if movement < 0 else "right" if movement > 0 else parent.prev_look_dir
	parent.prev_look_dir = parent.look_dir

func get_movement_input(left: String, right: String) -> float:
	return move_component.get_movement_direction(left, right)

func get_jump(jump: String) -> bool:
	return move_component.wants_jump(jump)

func can_jump() -> bool:
	return parent.jump_count < parent.max_jump_count and not parent.jump_timer

func get_shoot(shoot: String) -> bool:
	return move_component.wants_shoot(shoot)
