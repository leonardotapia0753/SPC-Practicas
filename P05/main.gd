extends Node

@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
var score
var coin_counter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	coin_counter = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_coin_counter(coin_counter)
	$HUD.show_message("Preparate")
	$Music.play()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Create a new instance of the Mob scene.
	var coin = coin_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $ItemPath/ItemSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var coin_spawn_location = $ItemPath/ItemSpawnLocation
	coin_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the coin's position to the random location.
	coin.position = coin_spawn_location.position
	
	# Set the mob's direction perpendicular to the path direction.
	var mob_direction = mob_spawn_location.rotation + PI / 2
	
	# Set the coin's direction perpendicular to the path direction.
	var coin_direction = coin_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	mob_direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = mob_direction
	coin_direction += randf_range(-PI / 4, PI / 4)
	coin.rotation = coin_direction

	# Choose the velocity for the mob.
	var mob_velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = mob_velocity.rotated(mob_direction)
	var coin_velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	coin.linear_velocity = coin_velocity.rotated(coin_direction)

	# Spawn the mob and coin by adding it to the Main scene.
	add_child(mob)
	add_child(coin)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_player_collect() -> void:
	coin_counter += 1
	$HUD.update_coin_counter(coin_counter)
