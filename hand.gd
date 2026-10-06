extends Node3D

const ads_lerp = 12.5


@onready var camera_3d: Camera3D = $".."
@export var origin_position: Vector3
@export var ads_position: Vector3
@export var origin_FOV: float
@export var ads_FOV: float
func _ready() -> void:
	position = origin_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ADS"):
		position = lerp(position,ads_position,ads_lerp * delta)
		camera_3d.fov = lerp(camera_3d.fov,ads_FOV, ads_lerp * delta)
	else:
		position = lerp(position,origin_position,ads_lerp * delta)
		camera_3d.fov = lerp(camera_3d.fov,origin_FOV, ads_lerp * delta)
