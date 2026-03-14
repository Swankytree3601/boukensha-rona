extends CharacterBody2D

@export var velocidad: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var direccion: Vector2 = Vector2.ZERO
var atacando: bool = false

func _physics_process(delta):
	# Movimiento
	if not atacando:
		direccion = Input.get_vector("player_1_left", "player_1_right", "player_1_up", "player_1_down")
	else:
		direccion = Vector2.ZERO
		
	# Atacar con espacio
	if Input.is_action_just_pressed("player_1_attack") and not atacando:
		atacar()
	
	# Aplicar movimiento
	velocity = direccion.normalized() * velocidad
	move_and_slide()
	
	# Animaciones
	if atacando:
		anim.play("attack")
	elif direccion != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
	
	# Voltear sprite
	if direccion.x != 0:
		anim.flip_h = direccion.x < 0

func atacar():
	atacando = true
	anim.play("attack")
	await anim.animation_finished
	atacando = false
	
	
	# Botones táctiles:
#Izquierda
func _on_go_left_button_down():
	Input.action_press("player_1_left")

func _on_go_left_button_up():
	Input.action_release("player_1_left")
	
#Derecha
func _on_go_right_button_down():
	Input.action_press("player_1_right")

func _on_go_right_button_up():
	Input.action_release("player_1_right")

#Abajo	
func _on_go_down_button_down():
	Input.action_press("player_1_down")

func _on_go_down_button_up():
	Input.action_release("player_1_down")

#Arriba	
func _on_go_up_button_down():
	Input.action_press("player_1_up")

func _on_go_up_button_up():
	Input.action_release("player_1_up")
	
#Atacar
func _on_go_attack_pressed():
	Input.action_press("player_1_attack")
	Input.action_release("player_1_attack")
