extends Node2D

export(PackedScene) var Objeto
const objects_file = "res://data/objects.json"
var time_left = 0
var score = 0
var time_final = 0
var nivel = 1

func _ready():
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("fadeout")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	$ColorRect.visible = false
	time_left = 2
	time_final = 2
	$ObjectsContainer.visible = false
	$ObjectsSoundContainer.visible = false
	$ObjectsOptionsContainer.visible = false
	load_objects()
	first_sound()
	load_opciones()
	nivel = 1

func load_objects():
	var file = File.new()
	if file.file_exists(objects_file):
		file.open(objects_file, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			create_deck(data)
		else:
			printerr("Corrupted data!")
	else:
		printerr("File don't exist!")

func create_deck(json):
	var deck = Array()
	for i in json:
		deck.append(i)
	var indexList = range(deck.size())
	for i in range(deck.size()):
		randomize()
		var x = randi()%indexList.size()	
		for y in json:
			if y == deck[x]:
				var obj = Objeto.instance()
				obj.set_id(y)
				obj.set_nombre(json[y]["name"])
				obj.set_code(json[y]["code"])
				obj.set_sound(json[y]["sound"])
				obj.set_image(json[y]["image"])
				obj.position = Vector2(80,500)
				$ObjectsContainer.add_child(obj)
		indexList.remove(x)
		deck.remove(x)

func first_sound():
	# pasar el audio del objeto al button
	var count = 0
	var obj_x = 640
	var obj_width = 140
	for i in $ObjectsContainer.get_children():
		if count >= $ObjectsContainer.get_child_count() - 1:
			var obj = $ObjectsContainer.get_child(count)
			obj.position = Vector2(obj_x,300)
			obj_x = obj_x + obj_width
			$ObjectsContainer.remove_child(i)
			$ObjectsSoundContainer.add_child(obj)
			var ogg = AudioStreamOGGVorbis.new()
			ogg = load(obj.get_sound())
			ogg.loop = false
			$MarginContainerMain/VBoxContainer/TextureButtonAudio/AudioStreamPlayer.stream = ogg
		else:
			count += 1

func load_opciones():
	var file = File.new()
	if file.file_exists(objects_file):
		file.open(objects_file, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			generate_options(data)
		else:
			printerr("Corrupted data!")
	else:
		printerr("File don't exist!")

func generate_options(json):
	var count = 0
	var card_x = 400
	var card_width = 160
	var deck = Array()
	var tres = Array()
	for i in json:
		if json[i]["code"] != $ObjectsSoundContainer.get_child(0).code:
			deck.append(i)
	
	for y in json:
		if json[y]["code"] == $ObjectsSoundContainer.get_child(0).code:
			tres.append(y)
			
	var indexList = range(deck.size())
	for i in range(1):
		randomize()
		var x = randi()%indexList.size()	
		for y in deck:
			if y == deck[x]:
				tres.append(y)
		indexList.remove(x)
		deck.remove(x)
	
	var indice_tres = 0
	
	var in_list = range(tres.size())
	for i in range(2):
		randomize()
		var x = randi()%in_list.size()	
		for y in json:
			if y == tres[x]:
				var obj = Objeto.instance()
				obj.set_id(y)
				obj.set_nombre(json[y]["name"])
				obj.set_code(json[y]["code"])
				obj.set_sound(json[y]["sound"])
				obj.set_image(json[y]["image"])
				obj.position = Vector2(card_x,500)
				obj.add_to_group("deck")
				obj.connect("is_code", self, "_is_code", [obj])
				card_x = card_x + card_width
				$ObjectsOptionsContainer.add_child(obj)
				
				#var res = load(obj.get_image())
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.texture = res
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.texture.set_flags(1)
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.set_position(Vector2(75,75))
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.set_scale(Vector2(0.3,0.3))
				
				
				
				#var opt = Texture.new()
				#opt = load(obj.get_image())
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1.set_normal_texture(opt)
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1.set_stretch_mode(3)
				#$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1.set_scale(Vector2(0.1,0.1))
					
		in_list.remove(x)
		tres.remove(x)
		$ObjectsOptionsContainer.visible = true
		get_options()
		get_options2()

func get_options():
	#var count = 0
	#for i in $ObjectsOptionsContainer.get_children():		
	var obj = $ObjectsOptionsContainer.get_child(0)
	print(obj.get_image(),"---")
	
	var res = load(obj.get_image())
	$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.texture = res
	$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.texture.set_flags(1)
	$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.set_position(Vector2(75,75))
	$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption1/Sprite.set_scale(Vector2(0.3,0.3))
	#count += 1

func get_options2():
	var count = 0
	for i in $ObjectsOptionsContainer.get_children():		
		var obj = $ObjectsOptionsContainer.get_child(count)
		print(obj.get_image(),"---")
		var res = load(obj.get_image())
		$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption2/Sprite.texture = res
		$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption2/Sprite.texture.set_flags(1)
		$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption2/Sprite.set_position(Vector2(75,75))
		$MarginContainerMain/VBoxContainer/GridContainer/TextureButtonOption2/Sprite.set_scale(Vector2(0.3,0.3))
		count += 1
		
func _is_code(x):
	if $ObjectsSoundContainer.get_child(0).code == x.code:
		win()
	else:
		game_over()

func game_over():
	print("game over")
	$PopupMenuStatus.show()
	$PopupMenuStatus.updateStatustxt("INCORRECTA")
	$TimerResponse.start()

func win():
	score += 1
	$MarginContainerTop3.updateScore(score)
	print("you win")
	$PopupMenuStatus.show()
	$PopupMenuStatus.updateStatustxt("CORRECTA")
	$TimerResponse.start()



func _on_TextureButtonRegresar_pressed():
	#$Control2.visible = true
	$PopupMenuRegresar.show()
#	$ColorRect.visible = true
#	$ColorRect/AnimationPlayer.play("fadein")
#	yield($ColorRect/AnimationPlayer, "animation_finished")
#	get_tree().change_scene("res://title-screen/TitleScreen.tscn")

func _on_TextureButtonAudio_pressed():
	$MarginContainerMain/VBoxContainer/TextureButtonAudio/AudioStreamPlayer.play()


func _on_TextureButtonOption1_pressed():
	print("nose")


func _on_TextureButtonOption2_pressed():
	print("jue")



func _on_TimerResponse_timeout():
	time_left -=1
	if time_left <= 0:
		next_level()

func next_level():
	$PopupMenuStatus.visible = false
	$TimerResponse.stop()
	for i in $ObjectsContainer.get_children():
		$ObjectsContainer.remove_child(i)
	for i in $ObjectsSoundContainer.get_children():
		$ObjectsSoundContainer.remove_child(i)
	time_left = 2
	$ObjectsOptionsContainer.visible = false
	if $ObjectsOptionsContainer.get_child_count() != 0:
		load_objects()
		first_sound()
		load_opciones()
	else:
		$Control/Label.visible = true
		$TimerLevel.start()

func _on_TimerLevel_timeout():
	time_final -=1
	if time_final <= 0:
		get_tree().change_scene("res://title-screen/TitleScreen.tscn")


func _on_TextureButtonSi_pressed():
	$PopupMenuRegresar.hide()
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("fadein")
	yield($ColorRect/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://title-screen/TitleScreen.tscn")


func _on_TextureButtonNo_pressed():
	$PopupMenuRegresar.hide()
	#$Control2.visible = false
