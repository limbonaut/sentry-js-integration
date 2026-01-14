window.SentryBridge = {
	initialize: function (dsn, release) {
		if (window.Sentry) {
			Sentry.init({
				dsn: dsn,
				release: release,
				sampleRate: 1.0,
				debug: true,
				enableLogs: true,
				integrations: [window.Sentry.wasmIntegration()],
			});
			console.log("Sentry initialized via bridge");
		} else {
			console.error("Sentry JavaScript SDK not found!");
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
		console.log("Message captured.");
	},

	captureError: function (message, stacktraceJson) {
		try {
			var stacktrace = JSON.parse(stacktraceJson);
			Sentry.captureEvent({
				message: message,
				stacktrace: stacktrace,
			});
			console.log("Error captured.");
		} catch (e) {
			console.error("Failed to capture event:", e);
		}
	},
};
