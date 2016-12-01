/*
 * SocketAppender.vala
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
	public errordomain ConnectionError {
		CANNOT_RESOLVE,
		CANNOT_CONNECT
	}

	/**
	 * Append log data to a socket, using TCP or UDP, defined by the host and
	 * port.
	 */
	public class SocketAppender : Object,IAppender {
		private SocketConnection conn;

		public string name { get; set; }
		public ILayout? layout { get; set; }

		/**
		 * Hostname or IP address to connect to.
		 */
		public string host { get; set; }
		/**
		 * Port to connect to.
		 */
		public string port { get; set; }
		/**
		 * Protocol can be "tcp" or "udp", and defaults to tcp.
		 */
		public string protocol { get; set; default = "tcp"; }

		public void append( LogEvent event ) {
			try {
				get_connection().output_stream.write( "%s\n".printf( this.layout.format(event) ).data );
			} catch (Error e) {
				stderr.printf( "ERROR: %s\n", e.message );
			}
		}

		private SocketConnection? get_connection() throws ConnectionError {
			if ( conn == null || !conn.is_connected() ) {
				InetAddress address;
				try {
					// Resolve hostname to IP address
					var resolver = Resolver.get_default();
					var addresses = resolver.lookup_by_name( host, null );
					address = addresses.nth_data(0);
				} catch (Error e) {
					throw new ConnectionError.CANNOT_RESOLVE( e.message );
				}

				try {
					// Connect
					var client = new SocketClient();
					if ( protocol.down() == "udp" ) {
						client.protocol = SocketProtocol.UDP;
						client.type = SocketType.DATAGRAM;
					}
					conn = client.connect( new InetSocketAddress( address, (uint16) int.parse(port) ) );
				} catch (Error e) {
					throw new ConnectionError.CANNOT_CONNECT( e.message );
				}
			}

			return conn;
		}
	}
}