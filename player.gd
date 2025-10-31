extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var defPos

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword_sprite = $Sword
@onready var attack_area = $Attack
@onready var defend_area = $Defend
@onready var attack_col = $Attack/CollisionShape2D
@onready var defend_col = $Defend/CollisionShape2D

var win = false

func  _ready() -> void:
	defPos = $".".position
	if !SignalBus.is_connected("life", hearts):
		SignalBus.life.connect(hearts) 

func _physics_process(delta):
	if position.y > 1000 and SignalBus.health >= 1:
		position = defPos
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# apabila player tidak berdiri diatas permukaan, maka add gravity

	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("defend"):
		defend()
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and win == false:
		velocity.y = JUMP_VELOCITY
	# apabila tekan tombol spasi dan player diatas permukaan, maka lompat

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Get input direction -1, 0, 1
	var direction = 0
	if win == false:
		direction = Input.get_axis("move_left", "move_right")
	else:
		direction = 0
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
		sword_sprite.flip_h = false
		if(sword_sprite.position.x < 0):
			sword_sprite.position.x *= -1
			attack_col.position.x *= -1
			defend_col.position.x *= -1
		else:
			sword_sprite.position.x *= 1
			attack_col.position.x *= 1
			defend_col.position.x *= 1
	elif direction < 0:
		animated_sprite.flip_h = true
		sword_sprite.flip_h = true
		if(sword_sprite.position.x > 0):
			sword_sprite.position.x *= -1
			attack_col.position.x *= -1
			defend_col.position.x *= -1
		else:
			sword_sprite.position.x *= 1
			attack_col.position.x *= 1
			defend_col.position.x *= 1
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle") # jika 0 = idle
		else:
			animated_sprite.play("run") # jika tidak 0 = run
	else:
		animated_sprite.play("jump") # jika tidak on floor = jump
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	# bergerak sesuai arah tombol yang ditekkan

func attack():
	$AttackSound.play()
	sword_sprite.play("swing")
	var overlap = attack_area.get_overlapping_areas()
	for area in overlap:
		var parent = area.get_parent()
		print(parent.name)
		if parent.has_method("take_damage"):
			parent.take_damage(1)
	await get_tree().create_timer(0.5).timeout
	sword_sprite.play("idle")

func defend():
	sword_sprite.play("defend")
	$Defend/CollisionShape2D.disabled = false
	var overlap = defend_area.get_overlapping_bodies()
	for area in overlap:
		if area.has_method("ThrowBack"):
			print(area.name)
			area.ThrowBack()
	await get_tree().create_timer(0.5).timeout
	sword_sprite.play("idle")
	$Defend/CollisionShape2D.disabled = true

func hearts() -> void:
	SignalBus.health -= 1

func winEx():
	win = true

func take():
	sword_sprite.play("take")
	await  get_tree().create_timer(1).timeout
	sword_sprite.play("idle")

func action(col: Color):
	animated_sprite.play("action")
	animated_sprite.modulate = col
	animated_sprite.modulate.a = 0.5 
	await get_tree().create_timer(0.1).timeout
	animated_sprite.modulate = Color.WHITE
	animated_sprite.modulate.a = 1.0
	await get_tree().create_timer(0.1).timeout
	animated_sprite.modulate = col
	animated_sprite.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	animated_sprite.modulate = Color.WHITE
	animated_sprite.modulate.a = 1.0
	await  get_tree().create_timer(1).timeout
	sword_sprite.play("idle")

func die():
	$DeathSound.play()
	await $DeathSound.finished
