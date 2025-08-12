extends Node2D


var SentryJS: JavaScriptObject


func _ready():
	_add_utility_functions()
	_load_js_script("sentry-godot.js")
	_load_js_script("sentry-init.js")


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


func _on_capture_message_btn_pressed() -> void:
	# Test utility functions
	JavaScriptBridge.eval("helloWorld();")

	# Get JS Sentry interface
	SentryJS = JavaScriptBridge.get_interface("Sentry")
	print("DEBUG: Got interface: ", SentryJS)

	# Set context via custom interface
	var ctx := {
		"hello": "world",
		"gesture": "wave"
	}
	var SentryGodot: JavaScriptObject = JavaScriptBridge.get_interface("SentryGodot")
	SentryGodot.setContext("ctx", JSON.stringify(ctx))

	# Capture message
	SentryJS.captureMessage("Hello from GDScript")


func _on_crash_app_pressed() -> void:
	OS.crash("Crash button pressed") # doesn't work in WASM
