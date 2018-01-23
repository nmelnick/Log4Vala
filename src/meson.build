src_sources = files([
	'Config.vala',
	'Core.vala',
	'Level.vala',
	'LogEvent.vala',
	'Logger.vala',
	'LoggerCompat.vala',
	'LoggerConfig.vala',
	'Appender/IAppender.vala',
	'Appender/FileAppender.vala',
	'Appender/ScreenAppender.vala',
	'Appender/SocketAppender.vala',
	'Layout/ILayout.vala',
	'Layout/DescriptiveLayout.vala',
	'Layout/PatternLayout.vala',
	'Layout/SimpleLayout.vala'
])

lib = shared_library(
    library_name,
    sources: src_sources,
    dependencies: deps,
    vala_args: [
        '--internal-vapi', join_paths(meson.build_root(), 'src', library_name + '-internal.vapi'),
        '--internal-header', join_paths(meson.build_root(), 'src', library_name + '-internal.h')
    ],
    install: true,
    install_dir: [true, true, true]
)

pc = pkg.generate(
    libraries: lib,
    requires: deps_list,
    version: meson.project_version(),
    name: library_name,
    filebase: library_name,
    description: 'Logging library for Vala'
)

lib_dep = declare_dependency(
    sources: src_sources
)

install_data(
    library_name + '.deps',
    install_dir: join_paths(get_option('datadir'), 'vala', 'vapi')
)
