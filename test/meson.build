test_name = library_name + '-test'

test_sources = files([
	'AbstractTestCase.vala',
	'TestRunner.vala',
	'Config.test.vala',
	'Level.test.vala',
	'Logger.test.vala',
	'LoggerConfig.test.vala',
	'Layout.DescriptiveLayout.test.vala',
	'Layout.PatternLayout.test.vala',
	'Layout.SimpleLayout.test.vala',
])

test_deps = deps + [lib_dep]

tests = executable(
    test_name,
    sources: test_sources,
    dependencies: test_deps,
    install: false
)

test('tests', tests)
