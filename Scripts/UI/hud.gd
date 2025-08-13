extends CanvasLayer

func update_health(current: int, max: int) -> void:
	$HealthBar.max_value = max
	$HealthBar.value = current

func show_death_screen():
	$DeathScreen.visible = true

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score) + " exp"

func _on_reaparecer_pressed() -> void:
	$DeathScreen.visible = false
	for player in get_tree().get_nodes_in_group("player"):
		if player.is_multiplayer_authority():
			player.respawn()

func reset_attackbar(cooldown: float) -> void:
	$AttackBar.max_value = cooldown
	$AttackBar.value = 0.0
	
func set_attackbar(value: float) -> void:
	$AttackBar.value = value
