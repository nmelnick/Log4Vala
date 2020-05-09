/*
 * PatternLayout.vala
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

namespace Log4Vala.Layout {
	/**
	 * PatternLayout is a flexible layout that can be output with a formatting
	 * string.
	 */
	public class PatternLayout : Object,ILayout {
		private Regex PT_PATTERN = /[0-9%\-\.]/;

		/**
		 * Pattern to match the SimpleLayout.
		 */
		public const string SIMPLE_PATTERN = "%p - %m";
		/**
		 * Pattern to match the DescriptiveLayout.
		 */
		public const string DESCRIPTIVE_PATTERN = "%d{%Y-%m-%d %H:%M:%S} %5p %c %m %E{ | Error: Code %Ec, Domain %Ed, Message: %Em}";

		public string header { get; set; }
		public string footer { get; set; }
		public string pattern { get; set; }

		/**
		 * Characters available:
		 * || "Char" || "Description"
		 * || %%     || A percent sign ||
		 * || %c     || The category or logger name ||
		 * || %d     || The date. The date format character may be followed by a date format specifier enclosed between braces. For example, %d{%H:%M:%S,%l}. If no date format specifier is given, then the following format is used: "2014-06-18T09:56:21Z". The date format specifier admits the same syntax as the ANSI C function strftime, with 1 addition. The addition is the specifier %l for milliseconds, padded with zeros to make 3 digits. ||
		 * || %m     || The message ||
		 * || %n     || A line feed ||
		 * || %p     || The priority or log level ||
		 * || %R     || Seconds since Jan 1, 1970 or epoch ||
		 * || %E     || The error. The error format character may be followed by additional formatting in braces, where %Ec is the error code, %Ed is the domain, and %Em is the message. If no specifier is given, then the following format is used: "%Ec, %Ed, %Em". ||
		 * || %t     || The thread ID, if in a threaded environment ||
		 * || %P     || The process ID ||
		 */
		public string format( LogEvent event ) {
			var sb = new StringBuilder();
			int p = 0;
			while ( p < pattern.length ) {
				if ( pattern[p] == '%' ) {
					p++;
					var pattern_sb = new StringBuilder();
					pattern_sb.append("%");
					while ( PT_PATTERN.match( pattern[p].to_string() ) ) {
						pattern_sb.append(pattern[p].to_string());
						p++;
					}
					switch( pattern[p] ) {
					case 'c':
						pattern_sb.append("s");
						sb.append( pattern_sb.str.printf( event.logger_name ) );
						break;
					case 'd':
						var pattern_dt = new StringBuilder();
						if ( pattern[p+1] == '{' ) {
							p += 2;
							while ( pattern[p] != '}' && p < pattern.length ) {
								pattern_dt.append( pattern[p].to_string() );
								p++;
							}
						} else {
							pattern_dt.append("%FT%TZ");
						}
						pattern_sb.append("s");
						sb.append( pattern_sb.str.printf( event.timestamp.format( pattern_dt.str ) ) );
						break;
					case 'm':
						pattern_sb.append("s");
						sb.append( pattern_sb.str.printf( event.message ) );
						break;
					case 'n':
						pattern_sb.append("s");
						sb.append( pattern_sb.str.printf( "\n" ) );
						break;
					case 'p':
						pattern_sb.append("s");
						sb.append( pattern_sb.str.printf( event.log_level.friendly() ) );
						break;
					case 'R':
						pattern_sb.append("ld");
						sb.append( pattern_sb.str.printf( event.timestamp.to_unix() ) );
						break;
					case 'E':
						var pattern_er = new StringBuilder();
						if ( pattern[p+1] == '{' ) {
							p += 2;
							while ( pattern[p] != '}' && p < pattern.length ) {
								pattern_er.append( pattern[p].to_string() );
								p++;
							}
							p++;
						} else {
							pattern_er.append("%Ec, %Ed, %Em");
						}
						string er = pattern_er.str;
						pattern_sb.append("s");
						var er_substring = new StringBuilder();
						int erp = 0;
						while ( erp < er.length ) {
							if ( er[erp] == '%' ) {
								var pattern_ersb = new StringBuilder();
								pattern_ersb.append("%");
								bool er_in_pattern = true;
								while (er_in_pattern) {
									erp++;
									if ( PT_PATTERN.match( er[erp].to_string() ) ) {
										er_substring.append(er[erp].to_string());
									} else if ( er[erp] == 'E' ) {
										erp++;
										switch( er[erp] ) {
										case 'm':
											pattern_ersb.append("s");
											er_substring.append(
												pattern_ersb.str.printf(
													event.error.message
													)
												);
											er_in_pattern = false;
											break;
										case 'd':
											pattern_ersb.append( uint32.FORMAT );
											er_substring.append(
												pattern_ersb.str.printf(
													event.error.domain
													)
												);
											er_in_pattern = false;
											break;
										case 'c':
											pattern_ersb.append("d");
											er_substring.append(
												pattern_ersb.str.printf(
													event.error.code
													)
												);
											er_in_pattern = false;
											break;
										default:
											er_in_pattern = false;
											break;
										}
									}
								}
							} else {
								er_substring.append( er[erp].to_string() );
							}
							erp++;
						}
						if ( event.error != null ) {
							sb.append(
								pattern_sb.str.printf( er_substring.str )
								);
						}
						break;
					case 't':
						pattern_sb.append("ld");
						sb.append( pattern_sb.str.printf( event.thread_id ) );
						break;
					case 'P':
						pattern_sb.append("d");
						sb.append( pattern_sb.str.printf( event.process_id ) );
						break;
					default:
						break;
					}
				} else {
					sb.append( pattern[p].to_string() );
				}
				p++;
			}
			return sb.str;
		}
	}
}