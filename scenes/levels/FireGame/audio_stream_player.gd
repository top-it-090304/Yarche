extends AudioStreamPlayer
var effect
var recording
@onready var timer: Timer = $"../buffer_timer"
signal over_threshold

func _ready():
	setup_microphone()
	timer.wait_time = 0.5
	timer.timeout.connect(on_timer_timeout)
	effect.set_recording_active(true)
	timer.start()
	
func setup_microphone():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	if effect and idx:
		print("fdjfjddk")

func on_timer_timeout():
	effect.set_recording_active(false)
	recording = effect.get_recording()
	if recording != null:
		if (get_avg_rms_volume(recording) < 100):
			emit_signal("over_threshold")
			print("Задуваем")
		else:
			print("Сейчас такой средний уровень шума: ", get_avg_rms_volume(recording))
	effect.set_recording_active(true)

func get_avg_rms_volume(recording):
	var data = recording.get_data()
	var sum: float = 0 
	var step = max(1, data.size()/1000)
	var cnt = 0
	
	if data.size() >0:
		for i in range(0,data.size(),step):
			var sample = float(data[i]) - 128
			sum += sample*sample
			cnt +=1
	return sqrt(sum/cnt)
