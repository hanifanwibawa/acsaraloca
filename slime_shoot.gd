extends CharacterBody2D

const SPEED = 60

var follow = false
var right = false
var left = false
var player : CharacterBody2D

var wait_time = 1.0
var time_passed = 0.0
var has_timer_finished = false
var health = 2
var isBlocked = false
var flip

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

@export var Bullet : PackedScene

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
		animated_sprite.flip_h = false # slime arah kiri animasi
	if velocity.x < 0: # if slime arah kanan
		animated_sprite.flip_h = true # slime arah kanan animasi
	if ray_cast_left.is_colliding() == false and ray_cast_right.is_colliding() == false and (player.position - position).length() < 50:
		# if posisi antara player dan slime lebih kecil dari 50
		velocity = position.direction_to(player.position) # posisi velocity sama dengan player dan slime 
		velocity.x = 0 # velocity sama dengan nol slime berhenti
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


func shoot():
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.global_position = get_node("AnimatedSprite2D").global_position
	b.set_target(player.global_position)  # Set the target position

func _on_timeout() -> void:
	shoot() # memanggil fungsi shoot
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
