extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_mode := false

signal mode_changed(mode)

func gamemode(mode := false):
	if mode == current_mode: pass
	if mode == true:
		animation_player.play("tomode")
		await animation_player.animation_finished
		current_mode = true
		emit_signal("mode_changed", current_mode)
	if mode == false:
		animation_player.play("tobase")
		await animation_player.animation_finished
		current_mode = false
		emit_signal("mode_changed", current_mode)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		gamemode(!current_mode)
