extends Area2D

enum LavaState {
	WAITING,
	SLOW,
	FAST,
}

@export_category("Node References")
@export var collision: CollisionShape2D
@export var player1: Player2
@export var player2: Player2
@export_category("Timers")
@export var start_wait_timer: float = 2.0
@export var wait_timer: float = 5.0
@export var change_to_wait: float = 20.0
@export_category("Speed")
@export var slow_seconds: int = 60
@export var fast_seconds: int = 30
@export_category("Distance")
@export var change_range: float = 150.0

var current_state: LavaState = LavaState.WAITING
var state_change_timer: float = start_wait_timer

@onready var lava_size = collision.shape.size.x

func change_state(new_state: LavaState) -> void:
	current_state = new_state
	match current_state:
		LavaState.WAITING:
			state_change_timer = wait_timer
		LavaState.SLOW:
			pass
		LavaState.FAST:
			pass

func _process(delta: float) -> void:
	match current_state:
		LavaState.WAITING:
			state_change_timer -= delta
			if state_change_timer <= 0.0:
				state_change_timer = change_to_wait
				change_state(LavaState.FAST)
		LavaState.SLOW:
			position.y -= calc_move_dist(slow_seconds, delta)
			state_change_timer -= delta
			if state_change_timer <= 0.0:
				change_state(LavaState.WAITING)
			elif position.y - dist_to_player() > change_range:
				change_state(LavaState.FAST)
		LavaState.FAST:
			position.y -= calc_move_dist(fast_seconds, delta)
			state_change_timer -= delta
			if state_change_timer <= 0.0:
				change_state(LavaState.WAITING)
			elif position.y - dist_to_player() < change_range:
				change_state(LavaState.SLOW)

func calc_move_dist(seconds: int, delta: float) -> float:
	return lava_size / seconds * delta

func dist_to_player() -> float:
	return max(player1.global_position.y, player2.global_position.y)

func _on_body_entered(body: CharacterBody2D) -> void:
	if "die" in body:
		body.die()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Item"):
		area.queue_free()
