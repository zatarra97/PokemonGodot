#Tutte le proprietà del nodo Sprite
extends KinematicBody2D

enum TypeOfMovement{
  WALKING = 1
  RUNNING = 2
  CYCLING = 3
}

var bicycle = true 			#Verifica che il giocatore abbia sbloccato la bicicletta durante il gioco
var activeBicycle = false 	#Variabile boleana per attivare/disattivare la bicicletta
var waitForBicycle = false  #Quando la bici viene attivata/disattivata aspetterà che passino i frame di timeForBicycle
var timeForBicycle = 1		#Quanti frame bisogna aspettare prima di riprendere il movimento
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):	
	var direction = null		#Contiene la direzione dello Sprite
	
	if waitForBicycle == true:      			#Se bisogna aspettare dei frame per la bicicletta 
	  	waitForBicycle = waitingForReady()    	#Controlla che sia terminato il numero di frames di stop
	else:                            
		if Input.is_action_pressed("ui_up"):
			direction = "UP"
		elif Input.is_action_pressed("ui_down"):
			direction = "DOWN"
		elif Input.is_action_pressed("ui_left"):
			direction = "LEFT"
		elif Input.is_action_pressed("ui_right"):
			direction = "RIGHT"
				
		if Input.is_action_pressed("ui_bycicle") and (bicycle == true):		#Tasto che attiva la bicicletta
			var velocity = Vector2()
			waitForBicycle = true #Attiva un piccolo stop che aspetta qalche frame dopo aver mostrato/rimosso la bici
			timeForBicycle = 15 #Frames da aspettare
			if (activeBicycle == false):
				print("Bicycle activated")
				activeBicycle = true
				self.update_animation(velocity, activeBicycle)
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
	
	
func waitingForReady():	
	timeForBicycle -=1
	if timeForBicycle == 0:
		return false
	else: 
	    return true


func moving (speed, direction, delta):
	var velocity = Vector2()
	var bicycle = false
	
	if speed == TypeOfMovement.CYCLING:
		bicycle = true	
		
	if direction == "UP":
		velocity.y = 0 - speed
		print(velocity.y)
	elif direction == "DOWN":
			velocity.y = speed
			print(velocity.y)
	elif direction == "LEFT":
			velocity.x = 0 - speed
			print(velocity.x)
	elif direction == "RIGHT":
			velocity.x = speed
			print(velocity.x)
			
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
	
