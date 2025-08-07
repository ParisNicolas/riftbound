extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var max_health := 100
var current_health := 90
var is_dead := false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready():
	add_to_group("player")
	update_health_ui()
	if is_multiplayer_authority():
		$Camera2D.make_current()

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Empujar
	var collision = move_and_collide(velocity * delta)
	
	if collision and collision.get_collider().is_in_group("enemy"):
		var enemy = collision.get_collider()
		var push_dir = global_position.direction_to(enemy.global_position)
		enemy.apply_push(push_dir * 100)
	
	# Handle jump.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("mover_izquierda", "mover_derecha")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func take_damage(amount: int):
	if is_dead:
		return
		
	current_health = clamp(current_health - amount, 0, max_health)
	update_health_ui()
	
	if current_health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	
	var hud = get_tree().root.get_node("Node/HUD") # Ajustá ruta
	if hud:
		hud.show_death_screen()

func update_health_ui():
	var hud = get_tree().root.get_node("Node/HUD")  # Ajustá la ruta según tu estructura
	if hud:
		hud.update_health(current_health, max_health)

func respawn():
	print("REAPARICIONNN")
	max_health = max_health - 20
	current_health = max_health
	is_dead = false
	set_physics_process(true)
	update_health_ui()
