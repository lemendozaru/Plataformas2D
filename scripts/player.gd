extends CharacterBody2D

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

func _physics_process(delta: float):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# obtener la entrada
	move_input = Input.get_axis("left", "right")
	# movimiento
	velocity.x = move_input * move_speed
	move_and_slide()
