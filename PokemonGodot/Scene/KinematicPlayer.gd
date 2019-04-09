#Tutte le proprietà del nodo Sprite
extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Funzione che viene chiamata quando il nodo entra nella scena
func _ready():
	#stampa le coordinate dello sprite
	
	print("Now i'm walking to ", self.position)
	

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	
	#Corsa
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_interact"):
		velocity.y = -2
		print("RUN_UP")
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_interact"):
		velocity.y = 2
		print("RUN_DOWN")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_interact"):
		velocity.x = -2
		print("RUN_LEFT")
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_interact"):
		velocity.x = 2
		print("RUN_RIGHT")
		
	#Camminata normale
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -1
		print("UP")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1
		print("DOWN")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
		print("LEFT")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		print("RIGHT")
		
	
	var movement = 250*velocity*delta
	self.move_and_collide(movement)
	self.update_animation(velocity)
	
	
func update_animation(velocity):
	
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
			
			
	#Animazione da fermo
		if velocity == Vector2():
			if $AnimatedSprite.animation == 'walk_down' or $AnimatedSprite.animation == 'run_down' :
				$AnimatedSprite.play("stand_down")	
			elif $AnimatedSprite.animation == 'walk_up' or $AnimatedSprite.animation == 'run_up':
				$AnimatedSprite.play("stand_up")	
			elif $AnimatedSprite.animation == 'walk_left' or $AnimatedSprite.animation == 'run_left' :
				$AnimatedSprite.play("stand_left")	
			
