extends Node3D

var randx = randf_range(-4,4)
var randz = randf_range(-4,4)
var y_vel = 8
var gravity = 1

func set_amount(amount: int):
	$Label3D.text = str(amount)
	

func set_crit():
	$Label3D.font_size = 216
	$Label3D.modulate = Color.YELLOW

func _process(delta: float) -> void:
	position += Vector3(randx, y_vel, randz) * delta
	y_vel -= gravity



func _on_timer_timeout() -> void:
	queue_free()
