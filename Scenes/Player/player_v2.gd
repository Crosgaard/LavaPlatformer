class_name Player2 extends CharacterBody2D

signal arrow(pos: Vector2, is_p1: bool, power: bool)
signal player_has_died(is_p1: bool)

const SPEED: float = 250.0

@export_category("Basics")
@export var is_p1: bool
@export var dead_frame: int = 13
@export_category("Node references")
@export var jump_cooldown: Timer
@export var shoot_cooldown: Timer
@export var movement_animations: AnimationPlayer

var look_dir: String
var prev_look_dir: String

var jump_count: int = 0
var max_jump_count: int = 1
var jump_timer: bool = false

var shoot_timer: bool = false

# Power-ups
var shield: bool = false
var double_jump: bool = false
var power: bool = false
var rapid_fire: bool = false
var rapid_fire_max: int = 3
var rapid_fire_current: int = 0

var arrow_pos: Vector2

@onready var state_machine: Node = $StateMachine
@onready var player_move_component = $PlayerMoveComponent

func _ready() -> void:
	arrow_pos = $ArrowStartPositions/ASPtrue.global_position if is_p1 else $ArrowStartPositions/ASPfalse.global_position
	
	var player_dead_con: String
	player_dead_con = "player1_dead" if is_p1 else "player2_dead"
	movement_animations.animation_finished.connect(_on_animation_finsihed)
	shoot_cooldown.timeout.connect(_on_shoot_cooldown_finish)
	jump_cooldown.timeout.connect(_on_jump_cooldown_finish)
	state_machine.init(self, movement_animations, player_move_component, is_p1, player_dead_con)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_animation_finsihed(anim_name: String) -> void:
	#state_machine.on_animation_finished(anim_name)
	pass

func _on_animation_player_animation_finsihed(anim_name: String) -> void:
	state_machine.on_animation_finished(anim_name)

func _on_jump_cooldown_finish() -> void:
	jump_timer = false
	
func _on_shoot_cooldown_finish() -> void:
	shoot_timer = false
