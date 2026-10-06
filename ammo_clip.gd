extends Area3D
@export var AmmoAmount = 30
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
signal pickup
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(self,'position',Vector3(0,-0.2,0),1.0).as_relative().set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,'position',Vector3(0,0.2,0),1.0).as_relative().set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(self,'rotation',Vector3(0,1.0,0),1.0).as_relative()
	tween.set_loops()
	tween2.set_loops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_body_entered(body: Node3D) -> void:
	
	if body.is_in_group('player'):
		collision_shape_3d.disabled = true
		pickup.emit()
		print('ammoispickedup')
		body.pick_up_ammo(AmmoAmount)
		queue_free()
		
		
		
		
