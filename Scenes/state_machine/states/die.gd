extends State

var dying: bool
var prev_look_dir: String

func enter() -> void:
	prev_look_dir = parent.look_dir
	parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)
	dying = true

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	return null

func process_frame(delta: float) -> State:
	if dying:
		animations.play("die_" + prev_look_dir)
	return null

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "die_" + prev_look_dir:
		dying = false
		parent.player_has_died.emit(is_p1)
