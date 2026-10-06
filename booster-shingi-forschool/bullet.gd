extends Node3D

@onready var ray: RayCast3D = $RayCast3D

var bullet_speed: float = 30.0
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3.FORWARD * delta * bullet_speed
	
	
		
		
