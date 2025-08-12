extends Node2D


var SentryJS: JavaScriptObject


func _ready():
	_add_utility_functions()
	_add_interface()
	_init_sentry()


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


func _add_interface() -> void:
	JavaScriptBridge.eval("""
		window.SentryGodot = {

			setContext: function (name, dic) {
				console.log("DEBUG: SentryGodot::setContext key:" + name + " value: " + dic);
			}

		};
	""")


func _init_sentry() -> void:
	JavaScriptBridge.eval("""
		loadScript('sentry.js', function() {
			console.log('Sentry SDK loaded');

			loadScript('sentry-godot.js', function() {
				console.log('sentry-godot script loaded');
			});

			if (window.Sentry) {
				Sentry.init({
					dsn: 'https://3f1e095cf2e14598a0bd5b4ff324f712@o447951.ingest.us.sentry.io/6680910',
					release: 'sentry-godot-web-test@1.0.0-alpha.3',
					integrations: [],
					tracesSampleRate: 1.0,
					debug: true
				});
				console.log('Sentry initialized dynamically!');
			} else {
				console.error('Sentry SDK not loaded after script injection');
			}
		});

	""", true)


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
