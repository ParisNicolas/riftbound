extends CharacterBody2D

@export var SPEED := 80
@export var ATTACK_RANGE := 15
@export var ATTACK_COOLDOWN := 1.0
@export var GRAVITY := 800.0

var target_player: Node2D = null
var can_attack := true
var attacking := false

var max_health := 20
var current_health := 20
var is_dead := false

func _ready():
	add_to_group("enemy")
	var timer = Timer.new()
	timer.wait_time = ATTACK_COOLDOWN
	timer.one_shot = true
	timer.name = "AttackCooldown"
	add_child(timer)
	timer.connect("timeout", _on_attack_timeout)

func _physics_process(delta):
	find_closest_player()
	velocity.y += GRAVITY * delta

	attacking = false
	var direction = Vector2.ZERO

	if target_player:
		var dx = target_player.global_position.x - global_position.x
		var dy = target_player.global_position.y - global_position.y
		var distance = abs(dx)
		var height_distance = abs(dy)
		
		# Flip aunque no se mueva
		$AnimatedSprite2D.flip_h = dx < 0
		 
		if distance <= ATTACK_RANGE:
			if height_distance <= 10:
				velocity.x = 0
				if(can_attack):
					attack()
					print(distance)
					attacking = true
				$AnimatedSprite2D.play("attack")
			else:
				$AnimatedSprite2D.play("idle")
		else:
			# Perseguir horizontalmente
			direction.x = sign(dx)
			velocity.x = direction.x * SPEED
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = 0

	move_and_slide()
	
func take_damage(amount: int):
	if is_dead:
		return
		
	current_health = clamp(current_health - amount, 0, max_health)
	
	modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	modulate = Color(1, 1, 1)  # blanco normal (sin tinte)
	
	if current_health <= 0:
		die()
	
	
	
func apply_push(push_vector: Vector2):
	velocity += push_vector

func find_closest_player():
	var closest_distance = INF
	target_player = null

	for player in get_tree().get_nodes_in_group("player"):
		if not player or not player.is_inside_tree():
			continue

		var distance = global_position.distance_to(player.global_position)
		if distance < closest_distance:
			closest_distance = distance
			target_player = player


func attack():
	can_attack = false
	$AnimatedSprite2D.play("attack")
	
	target_player.take_damage(10)
			
	get_node("AttackCooldown").start()
	print("¡Ataque!")

func _on_attack_timeout():
	can_attack = true
	
func die():
	is_dead = true
	queue_free()
