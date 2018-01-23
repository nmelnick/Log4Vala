project ('log4vala', ['vala', 'c'], version: '0.2.1')

pkg = import('pkgconfig')
vala = meson.get_compiler('vala')

message('Found Vala ' + vala.version())
if vala.version().version_compare('<0.26')
    error('Requires Vala >= 0.26')
endif

version_split = meson.project_version.split('.')
api_version = '.'.join([version_array[0], version_array[1]])
library_name = meson.project_name() + '-' + version_split

deps = [
    dependency('gobject-2.0'),
    dependency('gmodule-2.0'),
    dependency('glib-2.0'),
    dependency('gio-2.0'),
    vala.find_library('posix')
]

deps_list = [
    'gobject-2.0',
    'gmodule-2.0',
    'glib-2.0',
    'gio-2.0'
]

subdir('src')
subdir('test')
