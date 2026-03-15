extends Camera2D

# intensidad de la sacudida
var intensity : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# nos conectamos con la señal de daño
	get_parent().OnUpdateHealth.connect(_damage_shake)

func _damage_shake(_health : int):
	intensity = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# disminuiremos la intensidad del daño conforme pase el tiempo
	if intensity > 0:
		# interpolamos decrecientemente
		intensity = lerpf(intensity, 0, delta * 10)
		# el offset de la cámara toma un valor aleatorio
		offset = _get_random_offset()
		
# función que crea y devuelve el valor de offset para la cámara
func _get_random_offset() -> Vector2:
	var x = randf_range(-intensity, intensity)
	var y = randf_range(-intensity, intensity)
	return Vector2(x, y)
