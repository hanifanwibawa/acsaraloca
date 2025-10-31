extends CharacterBody2D

const SPEED = 60

var isBlocked = false
var follow = false
var right = false
var left = false
var player : CharacterBody2D  # Reference to the player
var health = 2
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding(): # if slime arah kanan menabrak
		flip = true
		velocity.x = -1 # berubah arah ke kiri
	if ray_cast_left.is_colliding(): # if slime arah kiri menabrak
		flip = false
		velocity.x = 1 # berubah arah ke kanan
	if velocity.x > 0: # if slime arah kiri
		animated_sprite.flip_h = false # arah kiri animasi
	if velocity.x < 0: # if slime arah kanan
		animated_sprite.flip_h = true # arah kanan animasi
	if ray_cast_left.is_colliding() == false and ray_cast_right.is_colliding() == false and (player.position - position).length() < 50:
		# if posisi antara player dan slime lebih kecil dari 50
		velocity = (player.position - position).normalized() # posisi velocity sama dengan player dan slime 
	if isBlocked:
		var backOffset = 10
		if !flip:
			velocity.x = -1
			position.x += velocity.x * backOffset * delta
		elif flip:
			velocity.x = 1
			position.x += velocity.x * backOffset * delta
	position.x += velocity.x * SPEED * delta

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
