# movement_pinia.gd
extends CharacterBody2D

# Variables exportadas (ajustables en el Inspector)
@export var velocidad: float = 200.0
@export var vida: int = 20
@export var daño_ataque: int = 1
@export var rango_ataque: float = 100.0

# Referencias a nodos hijos
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_attack: AudioStreamPlayer2D = $AudioAttack

# Variables de estado
var direccion: Vector2 = Vector2.ZERO
var atacando: bool = false

# ────────────────────────────────────────────────────────────────────────────
# Configuración inicial
func _ready():
	# Añadir al grupo "jugador" para que enemigos puedan encontrarlo
	add_to_group("jugador")
	
	# Configurar capas de colisión
	set_collision_layer_value(1, true)   # Capa 1 = Jugador
	set_collision_mask_value(3, true)    # Detectar enemigos (capa 3)

# ────────────────────────────────────────────────────────────────────────────
# Físicas y movimientos (se ejecuta 60 veces por segundo)

func _physics_process(delta):
	# Obtener dirección de movimiento (solo si no está atacando)
	if not atacando:
		direccion = Input.get_vector("player_1_left", "player_1_right", "player_1_up", "player_1_down")
	else:
		direccion = Vector2.ZERO
	
	# Detectar ataque
	if Input.is_action_just_pressed("player_1_attack") and not atacando:
		atacar()
	
	# Aplicar movimiento
	velocity = direccion.normalized() * velocidad
	move_and_slide()
	
	# Gestionar animaciones
	actualizar_animaciones()

# ────────────────────────────────────────────────────────────────────────────
# Animaciones
func actualizar_animaciones():
	if atacando:
		anim.play("attack")
	elif direccion != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("idle")
	
	# Voltear sprite según dirección
	if direccion.x != 0:
		anim.flip_h = direccion.x < 0

# ────────────────────────────────────────────────────────────────────────────
# Atacar
func atacar():
	atacando = true
	anim.play("attack")
	
	# Detectar enemigos en área de ataque (círculo alrededor del jugador)
	detectar_enemigos_cerca()
	
	# Reproducir sonido de ataque
	if audio_attack and audio_attack.stream:
		audio_attack.play()
	
	# Esperar a que termine la animación
	await anim.animation_finished
	atacando = false

func detectar_enemigos_cerca():
	# Obtener el espacio de física
	var espacio = get_world_2d().direct_space_state
	
	# Configurar la consulta de física
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = rango_ataque
	query.transform = global_transform
	query.collision_mask = 4  # Capa 3 en binario = 4 (2^2)
	
	# Ejecutar consulta
	var resultados = espacio.intersect_shape(query)
	
	# Procesar cada enemigo detectado
	for resultado in resultados:
		var enemigo = resultado.collider
		if enemigo and enemigo.has_method("recibir_daño"):
			enemigo.recibir_daño(daño_ataque)

# ────────────────────────────────────────────────────────────────────────────
# Vida y muerte
func recibir_daño(cantidad: int):
	vida -= cantidad
	
	if vida <= 0:
		morir()

func morir():
	# Opciones: reiniciar escena o mostrar pantalla de game over
	get_tree().reload_current_scene()

# ────────────────────────────────────────────────────────────────────────────
# Botones táctiles (Android)
func _on_go_up_button_down():
	Input.action_press("player_1_up")

func _on_go_up_button_up():
	Input.action_release("player_1_up")

func _on_go_down_button_down():
	Input.action_press("player_1_down")

func _on_go_down_button_up():
	Input.action_release("player_1_down")

func _on_go_left_button_down():
	Input.action_press("player_1_left")

func _on_go_left_button_up():
	Input.action_release("player_1_left")

func _on_go_right_button_down():
	Input.action_press("player_1_right")

func _on_go_right_button_up():
	Input.action_release("player_1_right")

func _on_go_attack_pressed():
	Input.action_press("player_1_attack")
	Input.action_release("player_1_attack")
	atacar()
