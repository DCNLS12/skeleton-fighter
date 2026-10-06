extends CharacterBody3D

@onready var ray: RayCast3D = $Head/Camera3D/Ray
@onready var barrel: RayCast3D = $"Head/Camera3D/Hand/blaster-d/barrel"
@onready var gunshots_10: AudioStreamPlayer3D = $"Gunshots-10"
@onready var crit: AudioStreamPlayer3D = $Crit
@onready var ammo_label: Label = $CanvasLayer/HUD/ammo
@onready var health_num: Label = $CanvasLayer/HUD/HealthNum
@onready var reserve_ammo_label: Label = $CanvasLayer/HUD/reserve_ammo
@onready var reload_timer: Timer = $reload_timer
@onready var ar_reload: AudioStreamPlayer3D = $AR_reload
@onready var health_bar: ProgressBar = $CanvasLayer/HUD/HealthBar
@onready var recoil: AnimationPlayer = $Head/Camera3D/Hand/recoil
@export var crit_chance: float
const TITLE_SCREEN = preload("uid://baky2mh8g1ml7")
const BULLET = preload("res://bullet.tscn")

var AR_dmg = 15
var clip_size = 20
var reserve_ammo = 100
var ammo = 20
var is_alive: bool = true
@export var max_health = 100
var health = max_health
@onready var camera_3d: Camera3D = $Head/Camera3D
var SPEED = 10.0
const JUMP_VELOCITY = 4.5
const mouse_damp = 0.1

func update_hud():
	$CanvasLayer/HUD/MoneyLabel.text = '$ ' + str(Game.money)
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) ->void:
	
	if event is InputEventMouseMotion:
		var vel_x =event.relative.x
		var vel_y =event.relative.y
		rotate_y(-deg_to_rad(vel_x)* mouse_damp)
		$Head.rotate_x(-deg_to_rad(vel_y)* mouse_damp)
		
		$Head.rotation.x = clamp($Head.rotation.x,deg_to_rad(-85),deg_to_rad(85))
	elif event is InputEventKey:
		
		if Input.is_action_just_pressed('reload'):
			if ammo < clip_size and $reload_timer.is_stopped():
				$reload_timer.start()
				ar_reload.pitch_scale = randf_range(0.9,1.1)
				ar_reload.play()

				
func update_UI():
	ammo_label.text = str(ammo)
	reserve_ammo_label.text = str(reserve_ammo)



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed('shoot') and $cooldown.time_left == 0 and ammo > 0 and $reload_timer.is_stopped():
		ammo -= 1
		update_UI()
		
		if Input.is_action_pressed("ADS"):
			recoil.play('Kickback ADS')
			gunshots_10.play()
		else:
			recoil.play('Kickback')
			gunshots_10.play()
		if ray.is_colliding(): 
			var collider = ray.get_collider()
			print(ray.get_collision_point())
			if collider.is_in_group('damageable'):
				var collide_point = ray.get_collision_point()
				if randf() <= crit_chance:
					print('crit')
					collider.take_damage(2 * AR_dmg, collide_point, true)
					crit.play()
				else:
					collider.take_damage(AR_dmg, collide_point)
					gunshots_10.play()
				#if collider.is_in_group('head_damgeable'):
					#collider.head_take_damage(20)
				
			
		var bullet = BULLET.instantiate()
		bullet.global_position = barrel.global_position
		bullet.basis = $Head.global_transform.basis
		get_parent().add_child(bullet)
			
		$cooldown.start()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY 
		
		



func _process(delta: float) -> void:
	if  Input.is_action_pressed('speed_up'):
		SPEED = 8
	else:
		SPEED = 5

#55
#67559297

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_reload_timer_timeout() -> void:
	var amount_to_reload = min(reserve_ammo, clip_size - ammo)
	print('reload')
	ammo += amount_to_reload 
	reserve_ammo -= amount_to_reload
	update_UI()


func pick_up_ammo(amount: int) -> void:
	print('player picks up ', amount, ' ammo')
	reserve_ammo += amount
	reserve_ammo_label.text = str(reserve_ammo)

func take_damage(amount: float) -> void:
	if not is_alive: return
	health -= amount
	var health_remaining = health / max_health * 100.0
	health_num.text = str(health)
	health_bar.value = health_remaining
	if health <= 0:
		is_alive = false
		set_physics_process(false)
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
