extends ParallaxBackground

@export var textura: Texture2D  # Arrastra tu textura de 256x256 aquí
@export var velocidad: float = 50.0

func _ready():
	# Crear capa parallax
	var layer = ParallaxLayer.new()
	layer.motion_mirroring = Vector2(256, 0)  # Importante: 256 es el ancho
	
	# Crear sprite
	var sprite = Sprite2D.new()
	sprite.texture = textura
	
	layer.add_child(sprite)
	add_child(layer)

func _process(delta):
	scroll_offset.x += velocidad * delta
