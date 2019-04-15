#Tutte le proprietà del nodo Sprite
extends KinematicBody2D

signal dialogue_started
var bicycle = false 		#Verifica che il giocatore abbia sbloccato la bicicletta durante il gioco
var activeBicycle = false 	#Variabile boleana per attivare/disattivare la bicicletta

enum TypeOfMovement{	#Contiene le velocità dei diversi tipi di movimento
  WALKING = 1
  RUNNING = 2
  CYCLING = 3
}


func _ready():
	pass 

func _process(delta):	
	var direction = null		#Contiene la direzione dello Sprite
	             
	if Input.is_action_pressed("ui_up"):
			direction = "UP"
			$RayCast2D.cast_to = Vector2(0, -30)
	elif Input.is_action_pressed("ui_down"):
			direction = "DOWN"
			$RayCast2D.cast_to = Vector2(0, 30)
	elif Input.is_action_pressed("ui_left"):
			direction = "LEFT"
			$RayCast2D.cast_to = Vector2(-30, 0)
	elif Input.is_action_pressed("ui_right"):
			direction = "RIGHT"
			$RayCast2D.cast_to = Vector2(30, 0)
				
	if Input.is_action_just_released("ui_bycicle") and (bicycle == true):		
			var velocity = Vector2()
			if (activeBicycle == false):
				print("Bicycle activated")
				activeBicycle = true
			else: 
				print("Bicycle disactivated")
				activeBicycle = false
			self.update_animation(velocity, activeBicycle)	
				
	if Input.is_action_pressed("ui_run") and direction != null and activeBicycle != true:
			moving(TypeOfMovement.RUNNING, direction, delta)
	elif activeBicycle == true and bicycle == true :
			moving(TypeOfMovement.CYCLING, direction, delta)
	elif direction != null or direction == null:
			moving(TypeOfMovement.WALKING, direction, delta)
			
			
	if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider !=null and Input.is_action_just_released("ui_action") and collider.name == "Bicycle":
				emit_signal("dialogue_started", collider.dialogue_text)
				bicycle=true
				collider.queue_free()	#Cancella lo sprite della bicicletta
				$AnimatedSprite.stop()	#ferma l'animazione dello sprite
				set_process(false)	#Blocca la funzione _process e quindi il giocatore
				


func moving (speed, direction, delta):
	var velocity = Vector2()
	var bicycle = false
	
	if speed == TypeOfMovement.CYCLING:
		bicycle = true	
		
	if direction == "UP":
		velocity.y = 0 - speed
	elif direction == "DOWN":
			velocity.y = speed
	elif direction == "LEFT":
			velocity.x = 0 - speed
	elif direction == "RIGHT":
			velocity.x = speed
			
	var movement = 250*velocity*delta
	self.move_and_collide(movement)
	self.update_animation(velocity,bicycle)
	
	
func update_animation(velocity,bicycle):
	#Animazione Camminata lenta
		if velocity.y == 1:
			$AnimatedSprite.play("walk_down")
		elif velocity.y == -1:
			$AnimatedSprite.play("walk_up")
		elif velocity.x == -1:
			$AnimatedSprite.play("walk_left")
			$AnimatedSprite.flip_h=false
		elif velocity.x == 1:
			$AnimatedSprite.play("walk_left")
			$AnimatedSprite.flip_h=true
	
	#Animazione Corsa
		if velocity.y == 2:
			$AnimatedSprite.play("run_down")
		elif velocity.y == -2:
			$AnimatedSprite.play("run_up")
		elif velocity.x == -2:
			$AnimatedSprite.play("run_left")
			$AnimatedSprite.flip_h=false
		elif velocity.x == 2:
			$AnimatedSprite.play("run_left")
			$AnimatedSprite.flip_h=true
			
	#Animazione Bicicletta
		if velocity.y == 3:
			$AnimatedSprite.play("ride_down")
		elif velocity.y == -3:
			$AnimatedSprite.play("ride_up")
		elif velocity.x == -3:
			$AnimatedSprite.play("ride_left")
			$AnimatedSprite.flip_h=false
		elif velocity.x == 3:
			$AnimatedSprite.play("ride_left")
			$AnimatedSprite.flip_h=true
			
	#Animazione da fermo a piedi
		if velocity == Vector2() and !(bicycle == true):
			if $AnimatedSprite.animation == 'walk_down' or $AnimatedSprite.animation == 'run_down' or $AnimatedSprite.animation == "ride_stand_down":
				$AnimatedSprite.play("stand_down")	
			elif $AnimatedSprite.animation == 'walk_up' or $AnimatedSprite.animation == 'run_up' or $AnimatedSprite.animation == "ride_stand_up":
				$AnimatedSprite.play("stand_up")	
			elif $AnimatedSprite.animation == 'walk_left' or $AnimatedSprite.animation == 'run_left' or $AnimatedSprite.animation == "ride_stand_left":
				$AnimatedSprite.play("stand_left")	
			
		#Animazione sprite fermo sulla bicicletta
		elif velocity == Vector2() and bicycle == true:
			if $AnimatedSprite.animation == 'ride_down' or $AnimatedSprite.animation == 'stand_down' or $AnimatedSprite.animation == 'walk_down':
				$AnimatedSprite.play("ride_stand_down")	
			elif $AnimatedSprite.animation == 'ride_up' or $AnimatedSprite.animation == 'stand_up' or $AnimatedSprite.animation == 'walk_up':
				$AnimatedSprite.play("ride_stand_up")	
			elif $AnimatedSprite.animation == 'ride_left' or $AnimatedSprite.animation == 'stand_left' or $AnimatedSprite.animation == 'walk_left':
				$AnimatedSprite.play("ride_stand_left")	
	

func _on_NinePatchRect_dialog_finished():
	set_process(true)		#Appena il dialogo finisce può riprendere il controllo sul Player