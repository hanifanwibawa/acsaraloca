extends CharacterBody2D

const SPEED = 60

var follow = false
var right = false
var left = false
var player : CharacterBody2D  # Reference to the player

var wait_time = 0.5
var time_passed = 0.0
var has_timer_finished = false
var health = 2
var isBlocked = false
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_player = $RayCastPlayer
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding() and ray_cast_right.get_collider() != player: # if slime arah kanan menabrak
		flip = true
		velocity.x = -1 # berubah arah ke kiri
	if ray_cast_left.is_colliding() and ray_cast_left.get_collider() != player: # if slime arah kiri menabrak
		flip = false
		velocity.x = 1 # berubah arah ke kanan
	if has_timer_finished == false: # timer real time
		time_passed += delta # waktu bertambah tiap frame
		if time_passed >= wait_time: # if waktu lebih dari sama dengan wait time
			has_timer_finished = true 
			_on_timeout() # memanggil fungsi _on_timeout
	if velocity.x > 0: # if slime arah kiri
		animated_sprite.flip_h = false # arah kiri animasi
		$RayCastPlayer.scale.x = 1 # memutar raycast sesuai face
	if velocity.x < 0: # if slime arah kanan
		animated_sprite.flip_h = true # arah kanan animasi
		$RayCastPlayer.scale.x = -1 # memutar raycast sesuai face
	if ray_cast_player.get_collider() == player:
		has_timer_finished = true 
		velocity = (player.position - position).normalized() # posisi velocity sama dengan player dan slime 
	else :
		has_timer_finished = false
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
