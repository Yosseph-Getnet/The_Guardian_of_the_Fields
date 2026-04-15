extends Node
class_name HeatManager

@export_group("Dependencies")
@export var state_node: Node

@export_group("Survival Settings")
@export var thirst_decay_rate: float = 2.0
@export var herd_damage_rate: float = 5.0

@export_group("Audio Settings")
@export var low_thirst_threshold: float = 30.0

signal thirst_changed(value: float)
signal thirst_changed_ui(value: float)
signal thirst_depleted()

var heartbeat_sfx: AudioStreamPlayer2D = null

var _was_depleted: bool = false
var _thirst_tick_accumulator: float = 0.0
const TICK_RATE: float = 0.1

const AUDIO_ENTER_THRESHOLD: float = 30.0
const AUDIO_EXIT_THRESHOLD: float = 32.0
var _audio_active: bool = false

func _ready() -> void:
	if not state_node:
		state_node = get_node_or_null("/root/Global")
	heartbeat_sfx = get_node_or_null("HeartbeatSFX")
	_validate_dependencies()
	_validate_config()
	_initialize_audio()

func _process(delta: float) -> void:
	if not state_node:
		return
	_thirst_tick_accumulator += delta
	while _thirst_tick_accumulator >= TICK_RATE:
		_thirst_tick_accumulator -= TICK_RATE
		_update_thirst(TICK_RATE)
		_apply_herd_penalty(TICK_RATE)
	_update_audio()

func _update_thirst(delta: float) -> void:
	state_node.player_thirst = clampf(state_node.player_thirst, 0.0, 100.0)
	var previous: float = state_node.player_thirst
	state_node.player_thirst = clampf(
		state_node.player_thirst - (thirst_decay_rate * delta),
		0.0,
		100.0
	)
	if not is_equal_approx(previous, state_node.player_thirst):
		thirst_changed.emit(state_node.player_thirst)
	if floor(previous) != floor(state_node.player_thirst):
		thirst_changed_ui.emit(state_node.player_thirst)
	if state_node.player_thirst <= 0.0 and not _was_depleted:
		_was_depleted = true
		thirst_depleted.emit()
	elif state_node.player_thirst > 0.0:
		_was_depleted = false

func _apply_herd_penalty(delta: float) -> void:
	if state_node.player_thirst <= 0.0:
		state_node.herd_integrity = max(
			state_node.herd_integrity - (herd_damage_rate * delta),
			0.0
		)

func _update_audio() -> void:
	if not heartbeat_sfx or not state_node:
		return
	if not _audio_active and state_node.player_thirst < AUDIO_ENTER_THRESHOLD:
		_audio_active = true
	elif _audio_active and state_node.player_thirst > AUDIO_EXIT_THRESHOLD:
		_audio_active = false
	if _audio_active:
		var safe_threshold: float = max(low_thirst_threshold, 0.01)
		var intensity: float = 1.0 - (state_node.player_thirst / safe_threshold)
		intensity = clampf(intensity, 0.0, 1.0)
		heartbeat_sfx.pitch_scale = lerp(1.0, 1.8, intensity)
		if not heartbeat_sfx.playing:
			heartbeat_sfx.play()
	else:
		if heartbeat_sfx.playing:
			heartbeat_sfx.stop()

func _initialize_audio() -> void:
	if heartbeat_sfx:
		heartbeat_sfx.stop()
		heartbeat_sfx.pitch_scale = 1.0

func _validate_dependencies() -> void:
	if not state_node:
		push_error("HeatManager: state_node is null.")
		return
	if not "player_thirst" in state_node:
		push_error("HeatManager: state_node missing 'player_thirst'.")
	if not "herd_integrity" in state_node:
		push_error("HeatManager: state_node missing 'herd_integrity'.")

func _validate_config() -> void:
	if low_thirst_threshold <= 0.0:
		push_error("HeatManager: low_thirst_threshold must be > 0.0")
