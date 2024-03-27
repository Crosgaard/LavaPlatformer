extends Path2D

@export var speed_scale = 1.

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("Move")
	animation.speed_scale = speed_scale
