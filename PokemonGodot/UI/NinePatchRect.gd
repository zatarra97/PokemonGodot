extends NinePatchRect
signal dialog_finished

func _ready():
	set_process(false)
	hide() #Nasconde il textbox
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_action"):
		hide()								#nasconde il box di dialogo
		set_process(false)
		emit_signal("dialog_finished")		#In modo tale che possa riprendere lo script del Kinematic Player


func _on_KinematicBody2D_dialogue_started(dialogue_text):
	$LabelBicycle.text = dialogue_text	#imposta il testo da mostrare
	show()								#mostra il box di dialogo
	set_process(true)
