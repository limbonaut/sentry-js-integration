window.SentryBridge = {
	initialize: function (dsn, release) {
		if (window.Sentry) {
			Sentry.init({
				dsn: dsn,
				release: release,
				integrations: [],
				sampleRate: 1.0,
				debug: true,
			});
			console.log("Sentry initialized dynamically!");
		} else {
			console.error("Sentry SDK not loaded after script injection");
		}
	},

	setContext: function (key, valueJson) {
		try {
			var value = JSON.parse(valueJson);
			Sentry.setContext(key, value);
			console.log("Context set:", key, value);
		} catch (e) {
			console.error("Failed to parse context JSON:", e);
		}
	},

	captureMessage: function (message) {
		Sentry.captureMessage(message);
	},

	captureError: function (message, stacktraceJson) {
		try {
			var stacktrace = JSON.parse(stacktraceJson);
			Sentry.captureEvent({
				message: message,
				stacktrace: stacktrace,
			});
			console.log("Event captured!");
		} catch (e) {
			console.error("Failed to capture event: ", e);
		}
	},
};
