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