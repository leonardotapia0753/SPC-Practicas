extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coin_values = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = coin_values.pick_random()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
