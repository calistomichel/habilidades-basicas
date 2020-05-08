extends Control

func _ready():
	$ColorRect.visible = false

func _on_TextureButton_pressed():
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("fadein")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://nivel1/Nivel1.tscn")

func _on_TextureButton2_pressed():
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("fadein")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://nivel2/Nivel2.tscn")

func _on_TextureButton3_pressed():
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("fadein")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://nivel3/Nivel3.tscn")