extends Area2D

@export var imageSp : Texture2D
@export var hanacaraka = false
@export var color = Color.BLACK
#signal untuk dikirim
signal words(add)
signal ha(str)

var max_hearts: int = 3
var hearts = max_hearts

var word_taken = false

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		if word_taken == false:
			body.take()
			body.action(Color.GREEN)
			word_taken = true
			$Audio.play()
			$Sprite.queue_free()
			if hanacaraka == true:
				emit_signal("words", 1)

func _on_ready() -> void:
	$Sprite.texture = imageSp
	$Sprite.modulate = color
	$AnimationPlayer.play("fly")
	emit_signal("ha", imageSp.resource_path.get_file().trim_suffix('.png'))
