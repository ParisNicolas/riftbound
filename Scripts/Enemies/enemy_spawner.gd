extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval := 5.0
@export var spawn_limit := 10
var spawned := 0

func _ready():
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.start()
	
	if multiplayer.is_server():
		$SpawnTimer.wait_time = spawn_interval
		$SpawnTimer.start()




func _on_spawn_timer_timeout() -> void:
	if spawned >= spawn_limit:
		return

	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position  # o random

	spawned += 1
