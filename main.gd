extends Node2D


var SentryJS: JavaScriptObject


func _ready():
	_add_utility_functions()
	_load_js_script("sentry-godot.js")
	_load_js_script("sentry-init.js")

	# Test utility functions
	JavaScriptBridge.eval("helloWorld();")


func _add_utility_functions() -> void:
	JavaScriptBridge.eval("""
		window.loadScript = function(src, onload) {
			var script = document.createElement('script');
			script.src = src;
			script.crossOrigin = 'anonymous';
			script.onload = onload;
			script.onerror = function() {
				console.error('Failed to load ' + src);
			};
			document.head.appendChild(script);
	    };

		window.helloWorld = function() {
			console.log("Hello, world!");
		};

	""")


func _load_js_script(p_script: String) -> void:
	JavaScriptBridge.eval("""
		loadScript("%s", function() {
			console.log("Loaded %s.");
		});
	""" % [p_script, p_script], true)


func _on_set_context_btn_pressed() -> void:
	# Set context via custom interface
	var ctx := {
		"hello": "world",
		"gesture": "wave"
	}
	var SentryGodot: JavaScriptObject = JavaScriptBridge.get_interface("SentryGodot")
	SentryGodot.setContext("ctx", JSON.stringify(ctx))


func _on_capture_message_btn_pressed() -> void:
	# Get JS Sentry interface
	SentryJS = JavaScriptBridge.get_interface("Sentry")
	print("DEBUG: Got interface: ", SentryJS)

	# Capture message
	SentryJS.captureMessage("Hello from GDScript")


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

	var SentryGodot: JavaScriptObject = JavaScriptBridge.get_interface("SentryGodot")
	SentryGodot.captureError("Error test", JSON.stringify(stacktrace))
