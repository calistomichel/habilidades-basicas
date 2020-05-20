extends Node2D

export(PackedScene) var Objeto
const objects_file = "res://data/objects.json"
var audio1 = AudioStreamPlayer.new()
var audio2 = AudioStreamPlayer.new()
var ogg = AudioStreamOGGVorbis.new()
var texture_normal = Texture.new()
var texture_pressed = Texture.new()
var texture_audio_pressed = Texture.new()
var json
var score
var intentos
var time_left
var seleccionado
var eleccion_correcta
var segundo_audio

func _ready():
	$Main/VBox/Margin2/Escuchar.texture_normal
	# Icons
	$Correct.visible = false
	$Correct2.visible = false
	$Incorrect.visible = false
	# Childs
	add_child(audio1)
	add_child(audio2)
	# Transition
	$Transition.visible = true
	$Transition/AnimationPlayer.play("fade-out")
	yield($Transition/AnimationPlayer, "animation_finished")
	$Transition.visible = false
	# Containers
	$Objects.visible = false
	$ObjectsSounds.visible = false
	$ObjectsOptions.visible = false
	# Vars
	score = 0
	intentos = 0
	time_left = 2
	seleccionado = 0
	eleccion_correcta = false
	segundo_audio = false
	# Functions
	$TopPanel.update_score(score)
	json = read_json()
	set_objects(json)
	set_sounds(2)
	set_options(json, 1)

func read_json():
	var file = File.new()
	if file.file_exists(objects_file):
		file.open(objects_file, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			printerr("Corrupted data!")
	else:
		printerr("File don't exist!")

func set_objects(x):
	var deck = Array()
	for i in x:
		deck.append(i)
	var indexList = range(deck.size())
	for i in range(deck.size()):
		randomize()
		var y = randi()%indexList.size()	
		for z in x:
			if z == deck[y]:
				var obj = Objeto.instance()
				obj.set_id(z)
				obj.set_nombre(x[z]["name"])
				obj.set_code(x[z]["code"])
				obj.set_sound(x[z]["sound"])
				obj.set_image(x[z]["image"])
				$Objects.add_child(obj)
		indexList.remove(y)
		deck.remove(y)

func set_sounds(x):
	var count = 0
	var countAudio = 0
	for i in $Objects.get_children():
		if count >= $Objects.get_child_count() - x:
			var obj = $Objects.get_child(count)
			$Objects.remove_child(i)
			$ObjectsSounds.add_child(obj)
			ogg = load(obj.get_sound())
			ogg.loop = false
			if countAudio == 0:
				audio1.stream = ogg
				countAudio += 1
			else:
				audio2.stream = ogg
		else:
			count += 1

func set_options(x, agregar):
	# Distribucion de los objetos
	var all = Array()
	var options = Array()
	for i in x:
		var existe = false
		for j in $ObjectsSounds.get_children():
			if x[i]["code"] == j.code:
				existe = true
		if existe == false:
			all.append(i)
		else:
			options.append(i)

	# Inclucion de objetos extras
	var indexList = range(all.size())
	for i in range(agregar):
		randomize()
		var y = randi()%indexList.size()
		for z in all:
			if z == all[y]:
				options.append(z)
		indexList.remove(y)
		all.remove(y)

	# Set options to ObjectsOptions
	var card_x = 470
	var card_width = 170
	var in_list = range(options.size())
	for i in range(options.size()):
		randomize()
		var y = randi()%in_list.size()	
		for z in x:
			if z == options[y]:
				var obj = Objeto.instance()
				obj.set_id(z)
				obj.set_nombre(x[z]["name"])
				obj.set_code(x[z]["code"])
				obj.set_sound(x[z]["sound"])
				obj.set_image(x[z]["image"])
				obj.position = Vector2(card_x,500)
				obj.connect("is_code", self, "_is_code", [obj])
				card_x = card_x + card_width
				$ObjectsOptions.add_child(obj)
		in_list.remove(y)
		options.remove(y)

# Funcion que se ejecuta al clickear en un objeto
func _is_code(x):
	#seleccionado += 1
	if seleccionado == 0 and segundo_audio == true:
		var existe = false
		for i in $ObjectsSounds.get_children():
			if i.code == x.code:
				existe = true
		if existe == true:
			#eleccion_correcta = true
			incorrect(x.position.x, x.position.y)
			#correct(x.position.x, x.position.y)
		else:
			correct(x.position.x, x.position.y)
#	elif seleccionado == 1 and segundo_audio == true:
#		var existe = false
#		for i in $ObjectsSounds.get_children():
#			if i.code == x.code:
#				existe = true
#		if existe == true:
#			correctNext(x.position.x, x.position.y)
#		else:
#			incorrectNext(x.position.x, x.position.y)
#	print(seleccionado)
	
func correct(x, y):
	seleccionado += 1
	intentos += 1
	score += 1
	$TopPanel.update_score(score)
	$Timer.start()
	$Correct.visible = true
	$Correct.position = Vector2(x, 500)
	$Correct/AnimationPlayer.play("scala")

func incorrect(x, y):
	seleccionado += 1
	intentos += 1
	$Timer.start()
	$Incorrect.visible = true
	$Incorrect.position = Vector2(x, 500)
	$Incorrect/AnimationPlayer.play("scala")

func correctNext(x, y):
	seleccionado += 1
	intentos += 1
	if eleccion_correcta == true:
		score += 1
		$TopPanel.update_score(score)
	print("ok")
	$Timer.start()
	$Correct2.visible = true
	$Correct2.position = Vector2(x, 500)
	$Correct2/AnimationPlayer.play("scala")

func incorrectNext(x, y):
	seleccionado += 1
	intentos += 1
	print("no")
	$Timer.start()
	$Incorrect.visible = true
	$Incorrect.position = Vector2(x, 500)
	$Incorrect/AnimationPlayer.play("scala")

func next():
	$Timer.stop()
	audio1.stop()
	audio2.stop()
	texture_audio_pressed = load("res://assets/buttons/button-audio-normal-02.png")
	$Main/VBox/Margin2/Escuchar.texture_normal = texture_audio_pressed
	# Icons
	$Correct.visible = false
	$Correct2.visible = false
	$Incorrect.visible = false
	# Functions
	reset_sounds()
	reset_options()
	# Containers
	$ObjectsOptions.visible = false
	# Vars
	time_left = 2
	seleccionado = 0
	eleccion_correcta = false
	segundo_audio = false
	if intentos < 5:
		# Functions
		set_sounds(2)
		set_options(json, 1)
	else:
		if score >= 4:
			audio1.stop()
			audio2.stop()
			$PopupFinal.show()
			print("desbloqueado nivel")
		else:
			audio1.stop()
			audio2.stop()
			texture_normal = load("res://assets/buttons/button-normal-reintentar.png")
			$PopupFinal/VBox/HBox/Margin1/Continuar.texture_normal = texture_normal
			texture_pressed = load("res://assets/buttons/button-pressed-reintentar.png")
			$PopupFinal/VBox/HBox/Margin1/Continuar.texture_pressed = texture_pressed
			$PopupFinal.show()
			print("fin")

func reset_sounds():
	for i in $ObjectsSounds.get_children():
		$ObjectsSounds.remove_child(i)

func reset_options():
	for i in $ObjectsOptions.get_children():
		$ObjectsOptions.remove_child(i)

# TopPanel
func _on_ToMenu_pressed():
	$PopupToMenu.show()

# Main
func _on_Escuchar_pressed():
	texture_audio_pressed = load("res://assets/buttons/button-audio-pressed-01.png")
	$Main/VBox/Margin2/Escuchar.texture_normal = texture_audio_pressed
	audio1.play()
	$ObjectsOptions.visible = true
	yield(audio1, "finished") 
	audio2.play()
	segundo_audio = true
	print(segundo_audio)
	yield(audio2, "finished")
	texture_audio_pressed = load("res://assets/buttons/button-audio-normal-02.png")
	$Main/VBox/Margin2/Escuchar.texture_normal = texture_audio_pressed

# PopupToMenu
func _on_Si_pressed():
	$PopupToMenu.hide()
	$Transition.visible = true
	$Transition/AnimationPlayer.play("fade-in")
	yield($Transition/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://title-screen/TitleScreen.tscn")

func _on_No_pressed():
	$PopupToMenu.hide()

# Timer
func _on_Timer_timeout():
	time_left -=1
	if time_left <= 0:
		next()

# PopupFinal
func _on_Finalizar_pressed():
	$PopupFinal.hide()
	$Transition.visible = true
	$Transition/AnimationPlayer.play("fade-in")
	yield($Transition/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://title-screen/TitleScreen.tscn")

func _on_Continuar_pressed():
	if score >= 4:
		$PopupFinal.hide()
		$Transition.visible = true
		$Transition/AnimationPlayer.play("fade-in")
		yield($Transition/AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://nivel1-3/Nivel1-3.tscn")
	else:
		$PopupFinal.hide()
		$Transition.visible = true
		$Transition/AnimationPlayer.play("fade-in")
		yield($Transition/AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://nivel1-2/Nivel1-2.tscn")