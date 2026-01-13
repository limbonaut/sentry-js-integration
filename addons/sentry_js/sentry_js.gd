@tool
extends EditorPlugin
## Registers export plugin that copies JS dependecies.


var _export_plugin: EditorExportPlugin


func _enter_tree() -> void:
	_enable_plugin()


func _enable_plugin() -> void:
	_export_plugin = SentryJS_ExportPlugin.new()
	add_export_plugin(_export_plugin)


func _disable_plugin() -> void:
	remove_export_plugin(_export_plugin)
	_export_plugin = null


class SentryJS_ExportPlugin extends EditorExportPlugin:
	## Copies JavaScript dependencies to exported directory.

	const JS_FOLDER = "res://js/"


	func _get_name() -> String:
		return "SentryJS_ExportPlugin"


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		return platform.get_os_name() == "Web"


	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		var export_dir := ProjectSettings.globalize_path(path.get_base_dir())

		print("Exporting to ", export_dir)

		_add_html_head_content()
		_copy_js_files(export_dir)


	func _add_html_head_content() -> void:
		var content := [
			'<script src="bundle.debug.min.js" crossorigin="anonymous"></script>',
			'<script src="wasm.debug.min.js" crossorigin="anonymous"></script>',
			'<script src="sentry-bridge.js" crossorigin="anonymous"></script>',
		]

		var head_include: String = get_export_preset().get("html/head_include")
		var adding := false
		for line in content:
			if not head_include.contains(line):
				print("  Adding HTML head content: ", line)

				if not adding:
					adding = true
					head_include += '\n<!-- Automatically added by Sentry SDK -->'

				head_include += '\n' + line

		get_export_preset().set("html/head_include", head_include)


	func _copy_js_files(export_dir: String) -> void:
		var dir := DirAccess.open(JS_FOLDER)
		if dir == null:
			push_error("Folder not found: %s" % JS_FOLDER)
			return

		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var src_abs := ProjectSettings.globalize_path(JS_FOLDER.path_join(file_name))
				var dest_abs := export_dir.path_join(file_name)

				var err := DirAccess.copy_absolute(src_abs, dest_abs)
				if err == OK:
					print("  Copied ", file_name)
				else:
					print("  Failed to copy %s (code %s)" % [file_name, err])
			file_name = dir.get_next()

		dir.list_dir_end()
