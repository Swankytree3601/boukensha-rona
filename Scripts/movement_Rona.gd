extends CharacterBody2D

@export var velocidad: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var direccion: Vector2 = Vector2.ZERO
var atacando: bool = false

func _physics_process(delta):
	if not atacando:
		direccion = Input.get_vector("player_2_left", "player_2_right", "player_2_up", "player_2_down")
	else:
		direccion = Vector2.ZERO
	# Atacar con espacio
	if Input.is_action_just_pressed("player_2_attack") and not atacando:
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
