extends CharacterBody2D

const SPEED = 60

var follow = false
var right = false
var left = false
var player : CharacterBody2D  # Reference to the player
var anim : AnimatedSprite2D

var wait_time = 0.25
var time_passed = 0.0
var has_timer_finished = false
var isBlocked = false
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_player = $RayCastPlayer
@onready var animated_sprite = $AnimatedSprite2D

var health = 2

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	anim = player.get_child(0)
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	if player != null:
		if ray_cast_right.is_colliding() and (player.position - position).length() > 50: # if slime arah kanan menabrak bukan player
			velocity.x = -1 # berubah arah ke kirianimasi
			flip = true
		elif ray_cast_left.is_colliding() and (player.position - position).length() > 50: # if slime arah kiri menabrak bukan player
			velocity.x = 1 # berubah arah ke kanan
			flip = false
	if velocity.x > 0: # if slime arah kiri
		animated_sprite.flip_h = false # arah kiri 
	if velocity.x < 0: # if slime arah kanan
		animated_sprite.flip_h = true # arah kanan animasi
	if (player.position - position).length() < 50: # apabila posisi diantara player dan enemy dibawah 50
		if anim.flip_h == true and animated_sprite.flip_h == false: # apabila player berhadapan dengan musuh
			velocity.x = 0
		elif anim.flip_h == false and animated_sprite.flip_h == true: # apabila player berhadapan dengan musuh
			velocity.x = 0
		else :
			velocity = (player.position - position).normalized()
	if isBlocked:
		var backOffset = 5
		if !flip:
			velocity.x = -1
			position.x += velocity.x * backOffset * delta
		elif flip:
			velocity.x = 1
			position.x += velocity.x * backOffset * delta
	position.x += velocity.x * SPEED * delta

func take_damage(damage: int) -> void:
	animated_sprite.play("dmg")
	await get_tree().create_timer(1).timeout
	health -= damage
	animated_sprite.play("default")
	if health <= 0:
		die()

func ThrowBack() -> void:
	isBlocked = true
	animated_sprite.play("dmg")
	await get_tree().create_timer(1).timeout
	isBlocked = false
	animated_sprite.play("default")

func die() -> void:
	print("Enemy died!")
	queue_free()
