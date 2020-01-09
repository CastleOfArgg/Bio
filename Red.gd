extends Sprite

const start_color = Color(0.5, 0.0, 0.0, 0.0)
const end_color = Color(1.0, 0.0, 0.0, 1.0)
var color := start_color

var acc_time := 0.0
export var total_time := 0.1
export var hold_time := 0.2

func _ready():
	Globals.connect(Globals.signal_pain_string, self, "toggle")
	set_process(false)

func _process(delta):
	var percent := acc_time / total_time
	acc_time = acc_time + delta
	if percent < 1.0:
		color = lerp(start_color, end_color, percent)
		material.set("shader_param/col", color)
	elif acc_time >= hold_time + total_time:
		material.set("shader_param/col", start_color)
		acc_time = 0.0
		set_process(false)

func toggle():
	if not is_processing():
		set_process(true)
	