extends CharacterBody2D

@export var SPEED := 100
@export var ATTACK_RANGE := 15
@export var ATTACK_COOLDOWN := 1.0
@export var GRAVITY := 800.0

var target_player: Node2D = null
var can_attack := true
var attacking := false

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

		if distance <= ATTACK_RANGE and height_distance <= 5 and can_attack:
			attack()
			velocity.x = 0
			attacking = true
		else:
			# Perseguir horizontalmente
			direction.x = sign(dx)
			velocity.x = direction.x * SPEED
	else:
		velocity.x = 0

	# Animaciones
	if attacking:
		if $AnimatedSprite2D.animation != "attack":
			$AnimatedSprite2D.play("attack")
	elif abs(velocity.x) > 1:
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")
	else:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")

	move_and_slide()
	
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
	get_node("AttackCooldown").start()
	print("¡Ataque!")

func _on_attack_timeout():
	can_attack = true
