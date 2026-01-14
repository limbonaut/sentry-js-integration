extends Node2D
## Example of Sentry JS integration in Godot.


# Sentry options
const DSN := "https://3f1e095cf2e14598a0bd5b4ff324f712@o447951.ingest.us.sentry.io/6680910"
const RELEASE := "sentry-godot-web-test@1.0.0-alpha.3"

var SentryBridge: JavaScriptObject


func _ready():
	_initialize_sentry()


func _initialize_sentry() -> void:
	SentryBridge = JavaScriptBridge.get_interface("SentryBridge")
	SentryBridge.initialize(DSN, RELEASE)


func _divide_by_zero() -> void:
	print("Going to divide some zeroes...")
	GameLogic.divide(10, 0)


func _generate_nonfatal_error(threaded: bool = false) -> void:
	# Create stacktrace data
	var stacktrace := {
		frames = [
			{
				filename = "player/damage.gd",
				function = "_on_area_entered",
				lineno = 12,
				in_app = true
			},
			{
				filename = "player/damage.gd",
				function = "_take_damage",
				lineno = 5,
				in_app = true
			},
		]
	}

	var message := "Error test (threaded)" if threaded else "Error test"
	SentryBridge.captureError(message, JSON.stringify(stacktrace))


func _on_set_context_btn_pressed() -> void:
	# Set context via custom interface
	var ctx := {
		"hello": "world",
		"gesture": "wave"
	}

	SentryBridge.setContext("ctx", JSON.stringify(ctx))


func _on_capture_message_btn_pressed() -> void:
	print("Capturing message...")

	# Capture message
	SentryBridge.captureMessage("Hello from GDScript")


func _on_capture_error_test_pressed() -> void:
	print("Capturing non-fatal error...")
	_generate_nonfatal_error()


func _on_capture_error_threaded_test_pressed() -> void:
	print("Capturing non-fatal error from worker thread...")
	var thread := Thread.new()
	thread.start(_generate_nonfatal_error.bind(true))
	thread.wait_to_finish()


func _on_native_division_test_pressed() -> void:
	print("C++ dividing some zeroes...")
	_divide_by_zero()


func _on_native_division_threaded_test_pressed() -> void:
	print("C++ dividing some zeroes from worker thread...")
	var thread := Thread.new()
	thread.start(_divide_by_zero)
	thread.wait_to_finish()
