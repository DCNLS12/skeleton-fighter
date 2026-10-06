extends Marker3D
const AI_ENEMY = preload("res://AI_enemy.tscn")
@onready var area_3d: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func has_overlapping_character(bodies):
	
	for body in bodies:
		if body is CharacterBody3D:
			return true
			
	return false

func spawn_enemy():
	var ai_enemy = AI_ENEMY.instantiate()
	ai_enemy.on_death.connect(get_parent().enemy_killed)
	add_child(ai_enemy)


func _on_timer_timeout() -> void:
	
	if not has_overlapping_character(area_3d.get_overlapping_bodies()):
		var ai_enemy = AI_ENEMY.instantiate()
		add_child(ai_enemy)
