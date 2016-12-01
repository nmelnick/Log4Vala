/*
 * FileAppender.vala
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

using Log4Vala.Layout;
namespace Log4Vala.Appender {
	/**
	 * Append log data to a file.
	 */
	public class FileAppender : Object,IAppender {
		public string name { get; set; }
		public ILayout? layout { get; set; }

		/**
		 * Path to filename to write to.
		 */
		public string filename { get; set; }
		/**
		 * Mode for log file creation. "append" will append to an existing file,
		 * "clobber" will overwrite it. Defaults to "append".
		 */
		public string mode { get; set; default = "append"; }
		/**
		 * Set buffered to "1" to enable buffered writes.
		 */
		public string buffered { get; set; default = "0"; }

		private OutputStream os;

		public void append( LogEvent event ) {
			if ( os == null ) {
				refresh_filehandle();
			}
			try {
				os.write( "%s\n".printf( this.layout.format(event) ).data );
			} catch (Error e) {
				stderr.printf( "Unable to log to file '%s': %s", filename, e.message );
			}
		}

		public void close_file() {
			if ( layout != null && layout.footer != null ) {
				try {
					os.write( "%s\n".printf(layout.footer).data );
				} catch (Error e) {
					stderr.printf( "Unable to log to file '%s': %s", filename, e.message );
				}
			}
			os = null;
		}

		private void refresh_filehandle() {
			try {
				bool new_file = false;
				var file = File.new_for_path(filename);
				FileOutputStream fos;
				if ( file.query_exists() && mode == "clobber" ) {
					file.delete();
					new_file = true;
					fos = file.create( FileCreateFlags.REPLACE_DESTINATION );
				} else if ( file.query_exists() ) {
					fos = file.append_to( FileCreateFlags.NONE );
				} else {
					new_file = true;
					fos = file.create( FileCreateFlags.REPLACE_DESTINATION );
				}
				if ( buffered != "0" ) {
					os = new BufferedOutputStream(fos);
				} else {
					os = new DataOutputStream(fos);
				}
				if (new_file) {
					if ( layout != null && layout.header != null ) {
						os.write( "%s\n".printf(layout.header).data );
					}
				}
			} catch (Error e) {
				stderr.printf( "Unable to log to file '%s': %s", filename, e.message );
			}
		}
	}
}