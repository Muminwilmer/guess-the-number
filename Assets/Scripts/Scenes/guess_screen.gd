extends Control

var num_range = Vector2(0, 100)
var random_num : int

func _ready() -> void:
	# Initialize random number when the scene is ready
	random_num = randi_range(num_range.x, num_range.y)
	$Guess.placeholder_text += " " + str(int(num_range.x)) + " - " + str(int(num_range.y))
	print(random_num)

func _gui_input(event: InputEvent) -> void:
	# Handles mouse scroll input for adjusting the guess
	if event is InputEventMouseButton and event.pressed and $Guess.has_focus():
		if event.is_action("scroll_up"):
			_increment_guess(1)
		elif event.is_action("scroll_down"):
			_increment_guess(-1)

func _increment_guess(amount: int) -> void:
	# Increment or decrement the guess value by a given amount
	var current_val := _get_current_guess()
	print(current_val)
	print(int($Guess.placeholder_text))
	if current_val == 0 and not int($Guess.placeholder_text) < 0:
		current_val = int($Guess.placeholder_text)
	var new_val := current_val + amount

	_set_guess_text(str(clamp(new_val, int(num_range.x), int(num_range.y))))

func _on_line_edit_text_submitted(new_text: String) -> void:
	# Called when the user submits their guess
	Global.tries += 1
	var guess = int($Guess.text)
	
	if guess == random_num:
		_show_success_message()
	else:
		_show_hint_message(guess)
		
	_clear_guess_input()

func _on_line_edit_text_changed(new_text: String) -> void:
	# Ensures that only numeric characters are entered
	var filtered = _filter_numeric_input(new_text)
	_set_guess_text(filtered)

func _input(event: InputEvent) -> void:
	# Handles global input actions, like resetting the game
	if event.is_action("reset"):
		get_tree().reload_current_scene()

# Utility functions
func _get_current_guess() -> int:
	return int($Guess.text)

func _set_guess_text(text: String) -> void:
	$Guess.text = text
	$Guess.caret_column = text.length()

func _filter_numeric_input(input: String) -> String:
	var filtered := ""
	for c in input:
		if c >= "0" and c <= "9":
			filtered += c
	return filtered

func _show_success_message() -> void:
	#$Message.text = "Correct! It took you (" + str(Global.tries) + ") Attempts. \nPress (R) to reset"
	#$Guess.editable = false
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelScenes/run_scene.tscn")
	
func _show_hint_message(guess: int) -> void:
	if random_num > guess:
		$Message.text = "(" + str(Global.tries) + ") The number is higher than: " + str(guess)
	elif random_num < guess:
		$Message.text = "(" + str(Global.tries) + ") The number is lower than: " + str(guess)

func _clear_guess_input() -> void:
	$Guess.placeholder_text = $Guess.text
	$Guess.text = ""
