window.SentryGodot = {
	setContext: function (key, valueJson) {
		try {
			var value = JSON.parse(valueJson);
			Sentry.setContext(key, value);
			console.log("Context set:", key, value);
		} catch (e) {
			console.error("Failed to parse context JSON:", e);
		}
	},
};
