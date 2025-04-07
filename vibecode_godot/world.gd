extends Node2D
var time_to_press := 3.0
var wanted_key := "a"
var score := 0
var keyboard_keys = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	"[", "]", ";", "'", ".", ",", "-", "=",
	"up", "down", "left", "right"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Crowd.play()
	$EarthGone.visible = false
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"QTE Timer".start(time_to_press)
	wanted_key = keyboard_keys.pick_random()
	$ButtonToPress.text = wanted_key
	while not Input.is_action_just_pressed(wanted_key):
		pass
	if not $"QTE Timer".is_stopped():
		score += 1
		if score % 5 == 0:
			time_to_press = clamp(time_to_press - 0.5, 0.1, time_to_press)
			print(time_to_press)

func _on_qte_timer_timeout() -> void:
	$AnimationPlayer.play("punch")
