extends Node2D

var speed = 100
var dest = Vector2.ZERO
var direction = Vector2.ZERO
var target_position_set = false
var lifetime = 3
var time_alive = 0.0

@onready var area = $Area2D

func _ready() -> void:
	pass # wait for dest to be set externally

func _process(delta: float) -> void:
	if target_position_set:
		position += direction * speed * delta

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func set_target(pos: Vector2):
	dest = pos
	direction = (dest - position).normalized()
	target_position_set = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player" and area.name == "Defend":
		$Sprite2D.queue_free()
