extends Resource
class_name SinWaveCollection

var amplitude:float
var waves: Array[SinWave]


func _init(_amplitude: float, _waves: Array[SinWave], _start_time: float) -> void:
	self.amplitude = _amplitude
	self.waves = _waves
	change_start_times(_start_time)


func change_amplitude(new_amplitude: float, new_start_time: float) -> SinWaveCollection:
	var new_waves: Array[SinWave]
	for wave in waves:
		new_waves.append(wave.multiply(self.amplitude))

	return SinWaveCollection.new(new_amplitude, new_waves, new_start_time)


func change_start_times(new_start_time: float) -> void:
	for wave in waves:
		wave.start_time = new_start_time


func switch_to_diminishing(time: float) -> void:
	for wave in waves:
		var current_y = wave.augmenting_wave_factor(time)
		wave.start_time = wave.transition_time * wave.START_SPEED * (current_y - 1) + time
		#print("temp")


func add(collection: SinWaveCollection) -> void:
	#var new_collection = collection.change_amplitude(1, start_time)
	self.waves += collection.waves


func function(time: float, slope: int = 0, debug: bool = false) -> float:
	var result = 0
	var msg = ""

	for wave in waves:
		result += wave.function(time, slope)
		msg += "%f + " % (wave.amplitude * amplitude)

	if debug:
		#print(len(waves))
		print(msg)

	return amplitude * result


func tangent(time: float, slope: int = 0) -> float:
	var result = 0

	for wave in waves:
		result += wave.tangent(time, slope)

	return amplitude * result


func check_delete_waves(time: float):
	var new_waves: Array[SinWave]
	for wave in waves:
		if wave.diminishing_wave_factor(time) > 0.05:
			new_waves.append(wave)
		else:
			pass

	waves = new_waves
