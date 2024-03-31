extends CanvasLayer

var winner: String:
	set(value):
		winner = value
		%RichTextLabel.text = "[center]%s[/center]" % value

func _on_button_pressed() -> void:
	get_tree().quit()
