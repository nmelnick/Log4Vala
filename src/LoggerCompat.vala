/*
 * LoggerCompat.vala
 *
 * The Log4Vala Project
 *
 * Copyright 2013-2016 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

namespace Log4Vala {
	/**
	 * Provides deprecated method compatibility without cluttering the Logger
	 * class.
	 */
	public interface LoggerCompat {
		/**
		 * Log a trace message, with formatting, via log().
		 * @param message Message to log
		 */
		public void trace_format( string message, ...  ) {
			var l = va_list();
			log( Level.TRACE, message.vprintf(l) );
		}

		/**
		 * Log a debug message, with formatting, via log().
		 * @param message Message to lo
		 */
		public void debug_format( string message, ... ) {
			var l = va_list();
			log( Level.DEBUG, message.vprintf(l) );
		}

		/**
		 * Log an info message, with formatting, via log().
		 * @param message Message to log
		 */
		public void info_format( string message, ... ) {
			var l = va_list();
			log( Level.INFO, message.vprintf(l) );
		}

		/**
		 * Log a warning message, with formatting, via log().
		 * @param message Message to log
		 */
		public void warn_format( string message, ... ) {
			var l = va_list();
			log( Level.WARN, message.vprintf(l) );
		}

		/**
		 * Log an error message, with formatting, via log().
		 * @param message Message to log
		 */
		public void error_format( string message, ... ) {
			var l = va_list();
			log( Level.ERROR, message.vprintf(l) );
		}

		/**
		 * Log a fatal message, with formatting, via log().
		 * @param message Message to log
		 */
		public void fatal_format( string message, ... ) {
			var l = va_list();
			log( Level.FATAL, message.vprintf(l) );
		}

		public abstract void log( Level log_level, string message, Error? e = null );
	}
}