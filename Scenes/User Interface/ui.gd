extends CanvasLayer

@onready var health_bar_1: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var health_bar_2: TextureProgressBar = $MarginContainer2/TextureProgressBar

func _ready():
	Globals.connect("health_change", update_health_ui)
	Globals.connect("shield_change", update_shield_ui)
	update_health_ui()
	update_shield_ui(false)

func update_health_ui():
	health_bar_1.value = Globals.health_p1
	health_bar_2.value = Globals.health_p2

func update_shield_ui(_is_p1):
	if Globals.shield_p1:
		health_bar_1.tint_progress = Color(0,200,255)
	else:
		health_bar_1.tint_progress = Color(0,255,0)
	
	if Globals.shield_p2:
		health_bar_2.tint_progress = Color(0,200,255)
	else:
		health_bar_2.tint_progress = Color(0,255,0)
