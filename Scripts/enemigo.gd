# enemigo.gd
extends CharacterBody2D

# Variables exportadas (ajustables en el Inspector)
@export var velocidad: float = 100.0
@export var daño: int = 1
@export var vida: int = 2  # Vida del enemigo

# Referencias a nodos hijos
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Variables de estado
var jugador = null
var atacando: bool = false
var muriendo: bool = false

# ─────────────────────────────────────────────────────────────────────────
# Configuración inicial
func _ready():
	# Buscar al jugador por grupo
	jugador = get_tree().get_first_node_in_group("jugador")
	
	# Configurar capas de colisión
	set_collision_layer_value(3, true)   # Capa 3 = Enemigos
	set_collision_mask_value(1, true)    # Detectar jugador (capa 1)

# ─────────────────────────────────────────────────────────────────────────
# Físicas y movimiento
func _physics_process(delta):
	if muriendo:
		return
	
	if not jugador:
		jugador = get_tree().get_first_node_in_group("jugador")
		return
	
	# Perseguir al jugador
	var direccion = (jugador.global_position - global_position).normalized()
	velocity = direccion * velocidad
	move_and_slide()
	
	# Animaciones según estado
	if atacando:
		anim.play("attack")
	elif velocity.length() > 0:
		anim.play("run")
	else:
		anim.play("idle")
	
	# Voltear sprite según dirección
	if direccion.x != 0:
		anim.flip_h = direccion.x < 0
	
	# Detectar colisión con jugador
	detectar_colision_jugador()

func detectar_colision_jugador():
	for i in range(get_slide_collision_count()):
		var colision = get_slide_collision(i)
		if colision.get_collider() == jugador and not atacando:
			atacar()

# ─────────────────────────────────────────────────────────────────────────
# atacar
func atacar():
	atacando = true
	anim.play("attack")
	
	# Hacer daño al jugador
	if jugador and jugador.has_method("recibir_daño"):
		jugador.recibir_daño(daño)
	
	# Esperar a que termine la animación
	await anim.animation_finished
	atacando = false

# ─────────────────────────────────────────────────────────────────────────
# Recibir daño y muerte
func recibir_daño(cantidad: int):
	if muriendo:
		return
	
	vida -= cantidad
	print("Enemigo vida: ", vida)
	
	if vida <= 0:
		morir()

func morir():
	muriendo = true
	atacando = false
	velocity = Vector2.ZERO
	anim.play("death")
	
	await anim.animation_finished
	queue_free()
