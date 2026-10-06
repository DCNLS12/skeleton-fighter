extends CharacterBody3D
signal on_death

const DMG_NUMBERS = preload("uid://duc4qeys2g41h")

var attackdmg = 15
var attackrange = 1.5
var agrorange = 10
var player = null
var dmg: int = 15
#var hdmg = 20
@onready var animation_player: AnimationPlayer = $Skeleton_Mage/AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var head_collision: CollisionShape3D = $HeadCollision
var took_dmg: bool = false
@export var health = 150
@export var SPEED = 3.0
const JUMP_VELOCITY = 4.5
var is_alive: bool = true

func take_damage(amount: float, hit_pos: Vector3, is_crit: bool = false) -> void:
	if not is_alive: return
	if is_in_group('damageable'):
		took_dmg = true
		var dmg_numbers = DMG_NUMBERS.instantiate()
		dmg_numbers.set_amount(amount)
		if is_crit:
			dmg_numbers.set_crit()
		#dmg_numbers.global_position = hit_pos
		get_tree().current_scene.add_child(dmg_numbers)
		dmg_numbers.global_position = global_position + Vector3(randf_range(0.2,0.2),2,randf_range(-0.2,0.2))
		health -= amount
	if health <= 0:
		var money = randi_range(15,25)
		Game.money += money
		remove_from_group('enemies')
		on_death.emit()
		print('dead')
		animation_player.play('Death_A')
		is_alive = false
		set_physics_process(false)
		collision_shape_3d.queue_free()
		head_collision.queue_free()

#func head_take_damage(amount: float) -> void:
	#if not is_alive: return
	#if is_in_group('damageable'):
		#health -= 20
	#if health <= 0:
		#print('dead')
		#animation_player.play('Death_A')
		#is_alive = false
		#set_physics_process(false)
		#collision_shape_3d.queue_free()
		#head_collision.queue_free()


func _ready() -> void:
	animation_player.play('Unarmed_Idle')
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player):
		#checking if the distance between player and enemy is in the agrorange
		var distancetoplayer = global_position.distance_to(player.global_position)
		if distancetoplayer <= agrorange or took_dmg:
			
			var direction = (player.global_position - global_position).normalized()
			direction.y = 0
			if distancetoplayer < attackrange:
				
				animation_player.play("1H_Melee_Attack_Chop")
			else:
				#print('walk towards player')
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				animation_player.play("Walking_A")
				look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func deal_damage():
	#print('deal damage to player')
	player.take_damage(attackdmg)
 
