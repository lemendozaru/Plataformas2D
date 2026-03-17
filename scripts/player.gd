extends CharacterBody2D

# Actualizar la vida - señal de daño
signal OnUpdateHealth (health : int)
# Actualizar el puntaje - señal de moneda
signal OnUpdateScore (score : int)

# puntos de vida
@export var health : int = 3

@onready var sprite : Sprite2D = $PlayerSprite

# velocidad máxima a la que nos moveremos
@export var move_speed : float = 100
# tasa de aceleración del personaje
@export var acceleration : float = 50
# tasa a la que iremos frenando al dejar de presionar algún control
@export var braking : float = 20
# fuerza de la gravedad aplicada al jugador
@export var gravity : float = 500
# fuerza del impulso al saltar
@export var jump_force : float = 200

# variable donde almacenaremos las entradas para el movimiento
var move_input : float

# Referencia al AudioStreamPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

# precarga del audio de daño
var take_damage_sfx : AudioStream = preload("res://assets/Audio/take_damage.wav")
# precarga del audio de las monedas
var coin_sfx : AudioStream = preload("res://assets/Audio/coin.wav")

func _physics_process(delta: float):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# obtener la entrada
	move_input = Input.get_axis("left", "right")
	# Si hay movimiento...
	if move_input != 0:
		# entonces la velocidad en x es interpolada entre el reposo y la aceleración
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	# si no
	else:
		# velocidad en x es interpolada entre el movimiento y el "freno"
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	# Salto
	# Si la tecla de salto ha sido presionada y estamos en el suelo...
	if Input.is_action_pressed("jump") and is_on_floor():
		# entonces la velocidad en y es la fuerza de salto negativa
		velocity.y = -jump_force
		
	move_and_slide()
	
func _process(_delta: float):
	# Si el caracter se está moviendo:
	if velocity.x != 0:
		# entonces si la velocidad en x es positiva, se gira el sprite
		sprite.flip_h = velocity.x > 0
		
	_manage_animations()
	
	if global_position.y > 200:
		game_over()
		
func _manage_animations():
	# si el caracter está en el aire:
	if not is_on_floor():
		# reproduce "jump"
		$AnimationPlayer.play("jump")
	# pero si se está moviendo:
	elif move_input != 0:
		$AnimationPlayer.play("move")
	# y si nada de eso ocurre:
	else:
		$AnimationPlayer.play("idle")
		
func take_damage(amount : int):
	# perdemos una cantidad de vida
	health -= amount
	# emitimos la señal de daño
	OnUpdateHealth.emit(health)
	_damage_flash()
	# reproducimos el sonido de daño
	play_sound(take_damage_sfx)
	# si la vida llega a cero:
	if health <= 0:
		# perdemos (pero diferimos la llamada a función)
		call_deferred("game_over")
		
func game_over():
	# volvemos a la escena principal
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
func increase_score(amount : int):
	PlayerStats.score += amount
	# emitimos señal de incremento de puntaje
	OnUpdateScore.emit(PlayerStats.score)
	# reproducimos el sonido de moneda
	play_sound(coin_sfx)
	
func _damage_flash():
	# coloreamos de rojo
	sprite.modulate = Color.RED
	# creamos un timer que dure 0.5s
	await get_tree().create_timer(0.05).timeout
	# devolvemos el color base
	sprite.modulate = Color.WHITE
	
func play_sound(sound : AudioStream):
	# "audio" transmitirá lo que tengamos en "sound"
	audio.stream = sound
	# y lo reproducirá
	audio.play()
