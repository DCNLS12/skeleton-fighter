extends Marker3D

@export var object: PackedScene

var has_pickup = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if not has_pickup:
		var pickup = object.instantiate()
		pickup.pickup.connect(get_parent()._on_ammo_clip_pickup)
		add_child(pickup)
		has_pickup = true


func _on_child_exiting_tree(node: Node) -> void:
	$Timer.start()
	has_pickup = false
