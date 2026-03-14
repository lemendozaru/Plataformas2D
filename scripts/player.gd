extends CharacterBody2D

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
	
func _process(delta: float):
	# Si el caracter se está moviendo:
	if velocity.x != 0:
		# entonces si la velocidad en x es positiva, se gira el sprite
		sprite.flip_h = velocity.x > 0
		
	_manage_animations()
		
func _manage_animations():
	# si el caracter está en el aire:
	if not is_on_floor():
		# reproduce "idle"
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
	# si la vida llega a cero:
	if health <= 0:
		# perdemos (pero diferimos la llamada a función)
		call_deferred("game_over")
		
func game_over():
	# volvemos al principio del nivel 1
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
func increase_score(amount : int):
	PlayerStats.score += amount
	print(PlayerStats.score)
