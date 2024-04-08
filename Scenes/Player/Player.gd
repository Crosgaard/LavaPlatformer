class_name Player extends CharacterBody2D

signal arrow(pos: Vector2, is_p1: bool, power: bool)
signal player_has_died(is_p1: bool)

const SPEED: float = 250.0

@export_category("Basics")
@export var is_p1: bool
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

var frames_shader: int = 0

# Power-ups
var shield: bool = false:
	set(value):
		shield = value
		if value:
			set_shield_shader()
			set_shader_frame()
		elif not double_jump:
			reset_shader()
		else:
			set_dj_shader()

var double_jump: bool = false:
	set(value):
		double_jump = value
		if value:
			max_jump_count = 2
			$Timers/DoubleJumpStop.start()
			set_dj_shader()
			set_shader_frame()
		else:
			max_jump_count = 1
			if not shield:
				reset_shader()
			else:
				set_shield_shader()

var power: bool = false
var rapid_fire: bool = false
var rapid_fire_max: int = 3
var rapid_fire_current: int = 0
var push_back: bool = false

var arrow_marker: Marker2D
var arrow_pos: Vector2

@onready var state_machine: Node = $StateMachine
@onready var player_move_component = $PlayerMoveComponent

func _ready() -> void:
	arrow_marker = $ArrowStartPositions/ASPtrue if is_p1 else $ArrowStartPositions/ASPfalse
	
	var player_dead_con: String
	if is_p1:
		player_dead_con = "player1_dead"
		prev_look_dir = "right"
	else:
		player_dead_con = "player2_dead"
		prev_look_dir = "left"
	
	Globals.connect("shield_change", update_shield)
	movement_animations.animation_finished.connect(_on_animation_finsihed)
	shoot_cooldown.timeout.connect(_on_shoot_cooldown_finish)
	jump_cooldown.timeout.connect(_on_jump_cooldown_finish)
	state_machine.init(self, movement_animations, player_move_component, is_p1, player_dead_con)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	arrow_pos = arrow_marker.global_position
	state_machine.process_frame(delta)
	if double_jump or shield:
		shader_process()

func hit(dmg: int) -> void:
	if not shield:
		if is_p1:
			Globals.health_p1 -= dmg
		else:
			Globals.health_p2 -= dmg
		$Sprite2D.material.set_shader_parameter("progress", 0.5)
		$Sprite2D.material.set_shader_parameter("color", Vector4(1,0,0,1))
		$Timers/HitShader.start()
	else:
		if is_p1:
			Globals.shield_p1 = false
		else:
			Globals.shield_p2 = false

# Shaders
func shader_process() -> void:
	var frames: int = Engine.get_frames_drawn() - frames_shader
	$Sprite2D.material.set_shader_parameter("progress", (1.0 + sin(frames*0.25))/4)

func set_shader_frame() -> void:
	frames_shader = Engine.get_frames_drawn()

func reset_shader() -> void:
	$Sprite2D.material.set_shader_parameter("progress", 0)

func set_shield_shader() -> void:
	$Sprite2D.material.set_shader_parameter("color", Vector3(0,0,0.5))

func set_dj_shader() -> void:
	$Sprite2D.material.set_shader_parameter("color", Vector4(0.3,1,0.3,1))

func die() -> void:
	if is_p1:
		Globals.player1_dead.emit()
	else:
		Globals.player2_dead.emit()

func update_shield(is_p1: bool) -> void:
	if self.is_p1 and is_p1:
		shield = Globals.shield_p1
	elif not self.is_p1 and not is_p1:
		shield = Globals.shield_p2

func _on_animation_finsihed(anim_name: String) -> void:
	state_machine.on_animation_finished(anim_name)

# Timers
func _on_jump_cooldown_finish() -> void:
	jump_timer = false
	
func _on_shoot_cooldown_finish() -> void:
	shoot_timer = false

func _on_hit_shader_timeout():
	reset_shader()

func _on_double_jump_stop_timeout():
	double_jump = false

func can_jump() -> bool:
	return jump_count < max_jump_count and not jump_timer

func set_jump() -> void:
	jump_count += 1
