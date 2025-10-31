extends Area2D

var rightWord = false
@export var Keys : int = 0;
@export var changeScene: PackedScene

func _on_ha_words(add: int) -> void:
	Keys += add
	if Keys == 3:
		rightWord = true
		print(rightWord)
	#mengambil signal dari hanacaraka (words)

func _on_body_entered(body: CharacterBody2D) -> void:
	if rightWord == true:
		body.winEx()
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("Door")
		SignalBus.transition = true
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(changeScene)
		#apabila true maka pemain pindah scene


func _on_na_words(add: int) -> void:
	Keys += add
	if Keys == 3:
		rightWord = true
		print(rightWord)
	#mengambil signal dari hanacaraka (words)


func _on_ha_true_words(add: Variant) -> void:
	Keys += add
	if Keys == 3:
		rightWord = true
		print(rightWord)


func _on_ha_true_2_words(add: Variant) -> void:
	Keys += add
	if Keys == 3:
		rightWord = true
		print(rightWord)


func _on_ha_true_3_words(add: Variant) -> void:
	Keys += add
	if Keys == 3:
		rightWord = true
		print(rightWord)
