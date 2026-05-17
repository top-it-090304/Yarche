extends AudioStreamPlayer
var effect
var recording
var silent_rms_level

@onready var timer: Timer = $buffer_timer
@onready var flame: Node2D = $"../Flame"

signal over_threshold
var sensitivity = 1.0

# Добавляем переменные для отображения информации
var current_rms_level = 0.0
var current_threshold = 0.0
var is_recording_active = false

func _ready():
	setup_microphone()
	await get_silent_level()  # Добавляем await, чтобы дождаться калибровки
	flame.win.connect(_end_of_recording)
	
	timer.wait_time = 0.5
	timer.timeout.connect(on_timer_timeout)
	effect.set_recording_active(true)
	timer.start()
	is_recording_active = true
	
	
func get_silent_level():
	await get_tree().create_timer(0.5).timeout  # Даём время прочитать сообщение
	
	var total = 0.0
	for i in range(5):
		await get_tree().create_timer(0.2).timeout
		effect.set_recording_active(true)
		await get_tree().create_timer(0.1).timeout
		effect.set_recording_active(false)
		var sample = effect.get_recording()
		if sample:
			var rms_val = get_avg_rms_volume(sample)
			total += rms_val
			#print("Замер %d RMS: %.3f" % (i+1, rms_val))
		effect.set_recording_active(true)
	
	silent_rms_level = total/5
	sensitivity = adjust_sensitivity(silent_rms_level)
	
	var noise_percent = silent_rms_level * 100
	
	print("Фоновый шум: ", silent_rms_level)
	print("Чувствительность: ", sensitivity)
	
func _count_silent_rms_level():
	silent_rms_level = get_avg_rms_volume(recording)
	print("уровень шума в тишине: ", silent_rms_level)

func setup_microphone():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	if effect and idx:
		print("Микрофон настроен")
	else:
		print("микрофон не найден")
func adjust_sensitivity(background_noise: float) -> float:
	# background_noise - уровень фонового шума (0.0 - 1.0)
	var noise_percent = background_noise * 100
	var new_sensitivity = 1.0
	
	if noise_percent < 20:
		new_sensitivity = 2.0
	elif noise_percent < 40:
		new_sensitivity = 1.75
	elif noise_percent < 60:
		new_sensitivity = 1.5
	else:
		new_sensitivity = 1.05
	
	return new_sensitivity

func on_timer_timeout():
	effect.set_recording_active(false)
	recording = effect.get_recording()
	if recording != null && silent_rms_level != null:
		current_rms_level = get_avg_rms_volume(recording)
		current_threshold = silent_rms_level * sensitivity
		
		if (current_rms_level > current_threshold):
			emit_signal("over_threshold")
			print("Задуваем, так как уровень шума - ", current_rms_level)
		else:
			print("Сейчас такой средний уровень шума: ", current_rms_level)
	effect.set_recording_active(true)

func get_avg_rms_volume(recording):
	var data = recording.get_data()
	if data.size() == 0:
		return 0.0
	
	var sum_squares = 0.0
	var step = max(1, data.size() / 500)  # берем 500 сэмплов
	
	# Для 16-bit аудио
	if recording.format == AudioStreamWAV.FORMAT_16_BITS:
		#print(1)
		for i in range(0, data.size() - 1, step * 2):
			# Декодируем 16-bit сэмпл (little-endian)
			var sample = data[i] | (data[i + 1] << 8)
			if sample >= 32768:
				sample -= 65536
			var normalized = float(sample) / 32768.0
			sum_squares += normalized * normalized
	else:  # 8-bit
		#print(2)
		for i in range(0, data.size(), step):
			var sample = (float(data[i]) - 128.0) / 128.0
			sum_squares += sample * sample
	
	var samples_taken = data.size() / step
	if recording.format == AudioStreamWAV.FORMAT_16_BITS:
		samples_taken /= 2
	
	return sqrt(sum_squares / max(samples_taken, 1))

func _end_of_recording():
	is_recording_active = false
	queue_free()
