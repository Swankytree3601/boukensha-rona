extends CharacterBody2D

@export var velocidad: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_attack: AudioStreamPlayer2D = $AudioAttack

var direccion: Vector2 = Vector2.ZERO
var atacando: bool = false

func _ready():
	add_to_group("jugador") 

func _physics_process(delta):
	#Moviento
	if not atacando:
		direccion = Input.get_vector("player_1_left", "player_1_right", "player_1_up", "player_1_down")
	else:
		direccion = Vector2.ZERO
		
	if Input.is_action_just_pressed("player_1_attack") and not atacando:
		atacar()
	
	velocity = direccion.normalized() * velocidad
	move_and_slide()
	
	if atacando:
		anim.play("attack")
	elif direccion != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
	
	if direccion.x != 0:
		anim.flip_h = direccion.x < 0

func atacar():
	atacando = true
	anim.play("attack")
	
	#Sonido de ataque
	if audio_attack and audio_attack.stream:
		audio_attack.play()
	
	await anim.animation_finished
	atacando = false
# Funciones para botones
#Go up -------------------------------------
func _on_go_up_button_down():
	Input.action_press("player_1_up")

func _on_go_up_button_up():
	Input.action_release("player_1_up")

#Go down -------------------------------------
func _on_go_down_button_down():
	Input.action_press("player_1_down")

func _on_go_down_button_up():
	Input.action_release("player_1_down")

#Go left -------------------------------------
func _on_go_left_button_down():
	Input.action_press("player_1_left")

func _on_go_left_button_up():
	Input.action_release("player_1_left")

#Go Right -------------------------------------
func _on_go_right_button_down():
	Input.action_press("player_1_right")

func _on_go_right_button_up():
	Input.action_release("player_1_right")

#Atack -------------------------------------
func _on_go_attack_pressed():
	Input.action_press("player_1_attack")
	Input.action_release("player_1_attack")
