extends Area2D

var Player: CharacterBody2D
var speed = 160
var chasing = false

@export var angryTexture: String = "res://Assets/Textures/Angry.png"
@export var happyTexture: String = "res://Assets/Textures/Happy.png"

var flash_timer := 0.0
var max_flash_interval := 0.8  # Start slow
var min_flash_interval := 0.05  # End fast
var flashing_time := 0.0
var total_flash_time := 0.0
var is_angry := false
var current_interval := 0.8

func _ready() -> void:
	Player = get_tree().get_first_node_in_group("Player")
	$Sprite2D.texture = load(happyTexture)

	flashing_time = max(0.01, 10 - Global.tries)
	print(Global.tries)
	print("Flashing duration before chase: ", flashing_time)

	$StartTimer.wait_time = flashing_time
	$StartTimer.start()
	$StartTimer.timeout.connect(_on_chase_timer_timeout)

func _on_chase_timer_timeout() -> void:
	set_process(true)

func _process(delta: float) -> void:
	if chasing:
		return

	total_flash_time += delta
	flash_timer += delta

	# Flash interval speeds up as time progresses
	var progress = clamp(total_flash_time / flashing_time, 0, 1)
	current_interval = lerp(max_flash_interval, min_flash_interval, progress)

	if total_flash_time >= flashing_time:
		$Sprite2D.modulate = Color.RED
		chasing = true
		set_process(false)
	else:
		if flash_timer >= current_interval:
			flash_timer = 0
			is_angry = !is_angry
			$Sprite2D.texture = load(angryTexture if is_angry else happyTexture)

func _physics_process(delta: float) -> void:
	if chasing and Player:
		var direction = (Player.global_position - global_position).normalized()
		global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelScenes/death.tscn")
