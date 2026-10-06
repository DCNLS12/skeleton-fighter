extends Node3D

var round: int = 1
@onready var player: CharacterBody3D = $"../player"

#@onready var enemy_spawner: Marker3D = $EnemySpawner
#@onready var enemy_spawner_2: Marker3D = $EnemySpawner2

func enemy_killed():
	
	player.update_hud()
	
	print('enemy killed')
	var enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies) == 0:
		round += 1
		start_round()


func start_round():
	var spawners = get_tree().get_nodes_in_group('spawners')
	var count = 0
	for spawner in spawners:
		spawner.spawn_enemy()
		count += 1 
		if count >= round * 2:
			break
