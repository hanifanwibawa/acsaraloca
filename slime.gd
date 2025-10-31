extends CharacterBody2D

const SPEED = 60

var direction = 1 # arah slime ke kanan
var health = 2
var isBlocked = false
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var col = $CollisionShape2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): # berjalan setiap frame	
	animated_sprite.play("default")
	if ray_cast_right.is_colliding(): # if slime arah kanan menabrak
		flip = true
		velocity.x = -1 # berubah arah ke kiri
		animated_sprite.flip_h = true # dan membalikkan animasi
	if ray_cast_left.is_colliding(): # if slime arah kiri menabrak
		flip = false
		velocity.x = 1 # berubah arah ke kanan
		animated_sprite.flip_h = false
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
