extends Path2D

@export var speed_scale: float = 1.0

@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animator.play("Move")
	animator.speed_scale = speed_scale
