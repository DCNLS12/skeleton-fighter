extends Node3D
@onready var ammo_recieved: AudioStreamPlayer3D = $AmmoRecieved
@onready var round_manager: Node3D = $RoundManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_manager.start_round()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ammo_clip_pickup() -> void:
	ammo_recieved.play()
