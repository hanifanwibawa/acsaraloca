extends CharacterBody2D

const SPEED = 60
const GRAVITY = 500.0
const JUMP_VELOCITY = -100.0  # Adjust jump strength as needed
var vertical_velocity = 0.0
var player : CharacterBody2D  # Reference to the player
var yPos
var health = 2

var wait_time = 0.5
var time_passed = 0.0
var has_timer_finished = false
var isBlocked = false
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_downR = $RayCast2D2
@onready var ray_cast_downL = $RayCast2D3
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	yPos = position.y
	velocity = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	# Apply gravity
	vertical_velocity += GRAVITY * delta
	# Check if on ground
	var on_ground = ray_cast_downR.is_colliding() or ray_cast_downL.is_colliding()
	if on_ground:
		vertical_velocity = 0
		position.y = yPos  # Snap back to initial y position if needed
	else:
		position.y += vertical_velocity * delta  # Apply gravity effect
	# Horizontal movement and collision checks
	if ray_cast_right.is_colliding() and (player.position - position).length() > 50:
		vertical_velocity = JUMP_VELOCITY  # Apply jump velocity
		position.y -= 16
	elif ray_cast_left.is_colliding() and (player.position - position).length() > 50:
		vertical_velocity = 0  # Apply jump velocity
		position.y -= 16
	# Sprite direction based on movement
	animated_sprite.flip_h = velocity.x < 0
	flip = velocity.x < 0
	# Check for proximity to player and obstacle collision for jump
	if (ray_cast_left.is_colliding() or ray_cast_right.is_colliding()) \
		and (player.position - position).length() < 50:
		has_timer_finished = true 
		# Jump by 16px if near the player and colliding with a non-player object
		vertical_velocity = JUMP_VELOCITY  # Apply jump velocity
		position.y -= 16  # Adjust position upwards by 16 pixels
	# Move towards player if not colliding and close to player
	elif not (ray_cast_left.is_colliding() or ray_cast_right.is_colliding()) \
		and (player.position - position).length() < 50:
		has_timer_finished = true 
		velocity = (player.position - position).normalized()
	# Apply horizontal movement
	if has_timer_finished == false: # timer real time
		time_passed += delta # waktu bertambah tiap frame
		if time_passed >= wait_time: # if waktu lebih dari sama dengan wait time
			has_timer_finished = true 
			_on_timeout() # memanggil fungsi _on_timeout
	if isBlocked:
		var backOffset = 10
		if !flip:
			velocity.x = -1
			position.x += velocity.x * backOffset * delta
		elif flip:
			velocity.x = 1
			position.x += velocity.x * backOffset * delta
	position.x += velocity.x * SPEED * delta

func _on_timeout() -> void:
	velocity.x *= -1 # berbalik arah
	time_passed = 0.0 # rsest waktu ke 0
	has_timer_finished = false # waktu kembali berulang

func ThrowBack() -> void:
	isBlocked = true
	animated_sprite.play("dmg")
	await get_tree().create_timer(1).timeout
	isBlocked = false
	animated_sprite.play("default")

func take_damage(damage: int) -> void:
	animated_sprite.play("dmg")
	await get_tree().create_timer(1).timeout
	health -= damage
	animated_sprite.play("default")
	if health <= 0:
		die()

func die() -> void:
	print("Enemy died!")
	queue_free()
