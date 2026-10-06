extends CanvasLayer
const LEVEL = preload("uid://ldsmn8knq7ab")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

 
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
