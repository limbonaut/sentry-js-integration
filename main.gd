extends Node2D
## Example of Sentry JS integration in Godot.
##
## ATTENTION: Must add this to `html/head_include` in the export options:
##
##   <script src="sentry.js" crossorigin="anonymous"></script>
##   <script src="sentry-bridge.js" crossorigin="anonymous"></script>


# Sentry options
const DSN := "https://3f1e095cf2e14598a0bd5b4ff324f712@o447951.ingest.us.sentry.io/6680910"
const RELEASE := "sentry-godot-web-test@1.0.0-alpha.3"

var SentryBridge: JavaScriptObject


func _ready():
	_initialize_sentry()


func _initialize_sentry() -> void:
	SentryBridge = JavaScriptBridge.get_interface("SentryBridge")
	SentryBridge.initialize(DSN, RELEASE)


func _on_set_context_btn_pressed() -> void:
	# Set context via custom interface
	var ctx := {
		"hello": "world",
		"gesture": "wave"

	}

	SentryBridge.setContext("ctx", JSON.stringify(ctx))


func _on_capture_message_btn_pressed() -> void:
	# Capture message
	SentryBridge.captureMessage("Hello from GDScript")


func _on_capture_error_test_pressed() -> void:
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

	SentryBridge.captureError("Error test", JSON.stringify(stacktrace))
