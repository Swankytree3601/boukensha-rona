extends CanvasLayer

func _ready():
	# Conectar botones por código (más fiable)
	$go_up.button_down.connect(_on_go_up_button_down)
	$go_up.button_up.connect(_on_go_up_button_up)
	$go_down.button_down.connect(_on_go_down_button_down)
	$go_down.button_up.connect(_on_go_down_button_up)
	$go_left.button_down.connect(_on_go_left_button_down)
	$go_left.button_up.connect(_on_go_left_button_up)
	$go_right.button_down.connect(_on_go_right_button_down)
	$go_right.button_up.connect(_on_go_right_button_up)
	$go_attack.pressed.connect(_on_go_attack_pressed)

func _on_go_up_button_down():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_up_button_down()

func _on_go_up_button_up():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_up_button_up()

func _on_go_down_button_down():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_down_button_down()

func _on_go_down_button_up():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_down_button_up()

func _on_go_left_button_down():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_left_button_down()

func _on_go_left_button_up():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_left_button_up()

func _on_go_right_button_down():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_right_button_down()

func _on_go_right_button_up():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_right_button_up()

func _on_go_attack_pressed():
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador._on_go_attack_pressed()
