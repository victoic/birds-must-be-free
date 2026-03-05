extends Node

var file_path: String = "user://stats.cfg"

var config: ConfigFile = ConfigFile.new()
var config_err: Error
const pw: String = 'e2706c950d2143932629b17c97cae046fde49f0bdfdef9f7b921fcd34b6f5988'
var num_deaths: int = 0
var num_revolutions: int = 0
var num_wins: int = 0

func _ready() -> void:
	if FileAccess.file_exists(file_path):
		load_config()
	else:
		set_config()

func get_value(section, key) -> Variant:
	if config_err == OK:
		return config.get_value(section, key)
	return 0

func set_config(nd: int = 0, nr: int = 0, nw: int = 0) -> void:
	if config_err == OK:
		print("Setting {0} | {1} | {2}".format([nd, nr, nw]))
		config.set_value('stats', 'num_deaths', nd)
		config.set_value('stats', 'num_revolutions', nr)
		config.set_value('stats', 'num_wins', nw)

func save_config(is_revolution: bool, is_win: bool) -> void:
	if config_err == OK:
		num_deaths += 1 if not is_win else 0
		num_revolutions += 1 if is_revolution else 0
		num_wins += 1 if is_win else 0
		set_config(num_deaths, num_revolutions, num_wins)
		config.save_encrypted_pass(file_path, pw)

func load_config():
	config_err = config.load_encrypted_pass(file_path, pw)
	if config_err == OK:
		num_deaths = get_value('stats', 'num_deaths')
		num_revolutions = get_value('stats', 'num_revolutions')
		num_wins = get_value('stats', 'num_wins')
		print("NUM_DEATHS: {0} | NUM_REVOLUTIONS: {1} | NUM_WINS: {2}".format([num_deaths, num_revolutions, num_wins]))
