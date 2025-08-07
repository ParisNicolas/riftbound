extends CanvasLayer

func update_health(current: int, max: int) -> void:
	$HealthBar.max_value = max
	$HealthBar.value = current

func show_death_screen():
	$DeathScreen.visible = true
	

func _on_reaparecer_pressed() -> void:
	$DeathScreen.visible = false
	for player in get_tree().get_nodes_in_group("player"):
		if player.is_multiplayer_authority():
			player.respawn()
