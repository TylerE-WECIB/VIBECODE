extends Node2D
var time_to_press := 3.0
var wanted_key := "a"
var score := 0
var key_pressed := true
var game_playing := true
var keyboard_keys = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"1", "2", "3", "4", "5", "6", "7", "8", "9",
	"[", "]", ";", "'", ">", "-",
	"up", "down", "left", "right",
	"~", "Left Shift", "Right Shift", "Left Alt", "Right Alt", "Left Ctrl", "Right Ctrl"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Crowd.play()
	$EarthGone.visible = false
	$ButtonToPress.visible = true
	$ProgressBar.visible = true
	$Restart.visible = false
	$"High Score".visible = false
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_playing:
		$ProgressBar.max_value = time_to_press
		$ProgressBar.value = $"QTE Timer".time_left
		if key_pressed:
			$"QTE Timer".start(time_to_press)
			var old_wanted_key = wanted_key
			while wanted_key == old_wanted_key:
				wanted_key = keyboard_keys.pick_random()
			$ButtonToPress.text = wanted_key.to_upper()
			key_pressed = false
			
		if Input.is_action_just_pressed(wanted_key) and not key_pressed:
			key_pressed = true
			if $AnimationPlayer.current_animation != "punch":
				$AnimationPlayer.stop()
			score += 1
			if score % 5 == 0:
				time_to_press = clamp(time_to_press - 0.5, 0.1, time_to_press)
				$AnimationPlayer.play("screen_shake_big")
			else:
				$AnimationPlayer.play("screen_shake")

func _on_qte_timer_timeout() -> void:
	game_playing = false
	$AnimationPlayer.play("punch")
	$ButtonToPress.visible = false
	$Music.stop()
	score*=15.8
	if score > Global.high_score:
		Global.high_score = score
	$ButtonToPress.text = str(score) + " Mt."
	$"High Score".text = "High Score: " + str(Global.high_score) + " Mt."


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
