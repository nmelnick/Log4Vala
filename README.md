# Log4Vala 0.2

Log4Vala is a logging framework for Vala (or other GLib/GObject projects),
heavily inspired by the syntax and architecture of Log4J and similar projects.
The purpose is to provide a powerful and customizable logging API for your
application or library.

## Installation

To install the project from the Git repository, you will need Vala 0.18 or
higher, and CMake. Check out the repository, enter the repository directory,
and enter the following:

```
mkdir build
cd build
cmake ..
make -j2
sudo make install
```

## Basic Usage

Using Log4Vala requires an initial initialization and configuration, then
each module should obtain and use a 'Logger' to log messages. Advanced config
is explained below, but we'll start with the defaults -- log to the screen,
use a simple format.

In your main() function, or the entry point to your library:

```
Log4Vala.init();
```

Then, inside each class or module, obtain a logger. You may want to provide it
as a private field, but there's no need to pass the logger around to each
method. The get_logger() call will always return the same object for a given
logger name.

```
public class TestClass : Object {
	private Log4Vala.Logger logger = Log4Vala.Logger.get_logger("TestClass");
}
```

With that logger, you can now log entries. There are six predefined log levels:
FATAL, ERROR, WARN, INFO, DEBUG, and TRACE. Your configured logging level has to
at least match the priority of the logging message. By default, the log level is
TRACE, so all log entries will be shown. Setting the default log level to WARN
would not show any messages in INFO, DEBUG, or TRACE.

To log, call the method matching the log level in your logger instance.

```
public void a_method() {
	logger.info("I am in a method!");

	// You may also call "log" with a log level.
	logger.log( Log4Vala.Level.INFO, "I am in a method!" );

	// You may also capture an error and log it.
	try {
		method_that_will_throw();
	} catch (Error e) {
		logger.error( "Error in throwable method!", e );
	}

	// Or, you can use the formatter method.
	logger.errorf("Oh no, an error! Error: %s", e.message);
}
```

You may also use async methods if you're in a run loop or event loop -- just
append _async to the end of your logging call.

```
public void a_method() {
	logger.info_async.begin("I am in a method!");

	// You may also call "log" with a log level.
	logger.log_async.begin( Log4Vala.Level.INFO, "I am in a method!" );
}
```

The Log4Vala in front of each call can be skipped with a ```using Log4Vala;``` at
the beginning of your vala file.

When you're ready to compile, add ```--pkg log4vala-0.1 -X -llog4vala-0.1``` to
your valac compile command.

## Appenders and Layouts

Log4Vala, much like other Log4* frameworks, utilizes a pipeline of logger to
layout to appender. A Layout determines how the log message will be formatted,
and an Appender will determine how the message will be stored. A few layouts
and appenders are included with Log4Vala, and you can also create your own.

### Appenders

* *ScreenAppender* will output log messages to the screen, and can be configured
to use STDOUT or STDERR for you to appropriate capture the output.
* *FileAppender* will output log messages to the given file, and either append
or overwrite that file.
* *SocketAppender* will output log messages to a socket listening at another
host and port.

### Layouts

* *SimpleLayout* is the default layout, with just the log level and the message,
and looks something like this:
```
WARN - This is a message!
```
* *DescriptiveLayout* includes most of the information one would need in a log,
and looks like this:
```
2014-01-01 15:31:48 WARN  example.class.foo This is a message!
```
* *PatternLayout* is a configurable layout, that allows one to set up an output
pattern, similar to a printf, and each log message will output that way. The options are as follows:

 | *Char* | *Description* |
 |--------|---------------|
 | %%     | A percent sign |
 | %c     | The category or logger name |
 | %d     | The date. The date format character may be followed by a date format specifier enclosed between braces. For example, %d{%H:%M:%S,%l}. If no date format specifier is given, then the following format is used: "2014-06-18T09:56:21Z". The date format specifier admits the same syntax as the ANSI C function strftime, with 1 addition. The addition is the specifier %l for milliseconds, padded with zeros to make 3 digits. |
 | %m     | The message |
 | %n     | A line feed |
 | %p     | The priority or log level |
 | %R     | Seconds since Jan 1, 1970 or epoch |
 | %E     | The error. The error format character may be followed by additional formatting in braces, where %Ec is the error code, %Ed is the domain, and %Em is the message. If no specifier is given, then the following format is used: "%Ec, %Ed, %Em". |
 | %t     | The thread ID, if in a threaded environment |
 | %P     | The process ID |

A pattern similar to the SimpleLayout would look like:
```
%d{%Y-%m-%d %H:%M:%S} %5p %c %m %E{ | Error: Code %Ec, Domain %Ed, Message: %Em}
```

## Configuration

By default, Log4Vala will write the log to STDOUT using ScreenAppender, via the
SimpleLayout format. To change the defaults, or alter logging based on the
logger name, some configuration should be changed.

### Configuration File

The default way in most Log4* frameworks is the configuration file. Log4Vala
uses a similar format to those other implementations. The configuration file
can set a default logger and level, set up new appenders and configure them, and
attach layouts to appenders. Individual loggers can also be configured.

To use a config file, provide Log4Vala with the path to the file within the init
statement, like so:

```
Log4Vala.init("/tmp/log4vala.conf");
```

Log4Vala will ignore empty lines, or lines that start with *#*, as they denote
a comment. Whitespace at the beginning or end of the line will be ignored.

A logger is configured with an optional log level, and one or more appenders.
They are comma-separated, and the appender must be defined with an appender
directive somewhere in the file. To define a default logger, configure
'log4vala.logger'. Otherwise, to define a configuration down the name chain, 
append it after logger. So, if you had a class called 'ExampleLib.Control', you
could configure logging using 'log4vala.logger.ExampleLib.Control'.

The order of loggers and appenders does not
matter, but a logger or appender must be named before they can be configured.

This example will set the default logger to a file at "/tmp/example.log", using
a format similar to ```[2014-01-01 15:01:38] WARN  test.class : A message```,
but only at ERROR or above.

```
log4vala.logger=ERROR, LOGFILE
    
log4vala.appender.LOGFILE=Log4Vala.Appender.FileAppender
log4vala.appender.LOGFILE.filename=/tmp/example.log
log4vala.appender.LOGFILE.mode=append
log4vala.appender.LOGFILE.layout=Log4Vala.Layout.PatternLayout
log4vala.appender.LOGFILE.layout.pattern=%d{%Y-%m-%d %H:%M:%S} %5p %c : %m
```

### Programmatically

Log4Vala can also be configured without the configuration file. Using the
Config singleton and creating objects, the same configuration can be duplicated.

```
var config = Log4Vala.Config.get_config();
config.root_level = Log4Vala.Level.ERROR;
config.root_appender = new Log4Vala.Appender.FileAppender();
config.root_appender.filename = "/tmp/example.log";
config.root_appender.mode = "append";
config.root_appender.layout = new Log4Vala.Layout.PatternLayout();
config.root_appender.layout.pattern = "%d{%Y-%m-%d %H:%M:%S} %5p %c : %m";
```
