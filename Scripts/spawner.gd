# spawner.gd
extends Node2D

# Array para múltiples tipos de enemigos
@export var tipos_enemigos: Array[PackedScene] = []
@export var max_enemigos: int = 200
@export var radio_spawn: float = 1100.0
@export var tiempo_entre_spawns: float = 0.5

# Variables internas
@onready var jugador = get_tree().get_first_node_in_group("jugador")
var enemigos_actuales: Array = []

# ────────────────────────────────────────────────────────────────────────────
# CONFIGURACIÓN INICIAL
# ────────────────────────────────────────────────────────────────────────────
func _ready():
	# Empezar a spawnear enemigos
	iniciar_spawn()

func iniciar_spawn():
	while true:
		# Limpiar enemigos muertos de la lista
		enemigos_actuales = enemigos_actuales.filter(func(e): return is_instance_valid(e))
		
		# Spawnear si no hemos llegado al máximo
		if enemigos_actuales.size() < max_enemigos and not tipos_enemigos.is_empty():
			spawn_un_enemigo()
		
		# Esperar antes del siguiente spawn
		await get_tree().create_timer(tiempo_entre_spawns).timeout

# ────────────────────────────────────────────────────────────────────────────
# SPAWN DE ENEMIGOS
# ────────────────────────────────────────────────────────────────────────────
func spawn_un_enemigo():
	if not jugador:
		jugador = get_tree().get_first_node_in_group("jugador")
		return
	
	# Elegir un tipo de enemigo aleatorio
	var indice_aleatorio = randi() % tipos_enemigos.size()
	var escena_elegida = tipos_enemigos[indice_aleatorio]
	
	# Instanciar el enemigo
	var enemigo = escena_elegida.instantiate()
	
	# Calcular posición aleatoria alrededor del jugador
	var angulo = randf_range(0, 2 * PI)
	var distancia = radio_spawn
	var posicion_spawn = jugador.global_position + Vector2(cos(angulo), sin(angulo)) * distancia
	
	# Posicionar enemigo
	enemigo.global_position = posicion_spawn
	
	# Añadir a la escena principal (NO como hijo del spawner)
	get_parent().add_child(enemigo)
	
	# Añadir a la lista de seguimiento
	enemigos_actuales.append(enemigo)

# ────────────────────────────────────────────────────────────────────────────
# MÉTODOS AUXILIARES
# ────────────────────────────────────────────────────────────────────────────
func get_cantidad_enemigos_vivos() -> int:
	return enemigos_actuales.size()

func eliminar_todos_enemigos():
	for enemigo in enemigos_actuales:
		if is_instance_valid(enemigo):
			enemigo.queue_free()
	enemigos_actuales.clear()
