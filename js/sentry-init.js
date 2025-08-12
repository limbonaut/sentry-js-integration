loadScript("sentry.js", function () {
	console.log("Sentry SDK loaded");

	loadScript("sentry-godot.js", function () {
		console.log("sentry-godot script loaded");
	});

	if (window.Sentry) {
		Sentry.init({
			dsn: "https://3f1e095cf2e14598a0bd5b4ff324f712@o447951.ingest.us.sentry.io/6680910",
			release: "sentry-godot-web-test@1.0.0-alpha.3",
			integrations: [],
			tracesSampleRate: 1.0,
			debug: true,
		});
		console.log("Sentry initialized dynamically!");
	} else {
		console.error("Sentry SDK not loaded after script injection");
	}
});
