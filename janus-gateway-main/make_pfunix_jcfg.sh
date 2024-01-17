#!/bin/bash

# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

cat << EOF > /usr/local/etc/janus/janus.transport.pfunix.jcfg
# You can also control a Janus instance using Unix Sockets. The only
# aspect you need to configure here is the path of the Unix Sockets
# server. Notice that by default the interface is disabled, as you need
# to specify the path(s) to bind to for the API(s).
general: {
	enabled = false					# Whether to enable the Unix Sockets interface
									# for Janus API clients
	#events = true					# Whether to notify event handlers about transport events (default=true)
	json = "indented"				# Whether the JSON messages should be indented (default),
									# plain (no indentation) or compact (no indentation and no spaces)
	#path = "/path/to/ux-janusapi"	# Path to bind to (Janus API)
	#type = "SOCK_SEQPACKET"		# SOCK_SEQPACKET (default) or SOCK_DGRAM?
}

# As with other transport plugins, you can use Unix Sockets to interact
# with the Admin API as well: in case you're interested in it, a different
# path needs to be provided.
admin: {
	admin_enabled = true					# Whether to enable the Unix Sockets interface
											# for Admin API clients
	admin_path = "/var/run/janus_admin.sock"	# Path to bind to (Admin API)
	admin_type = "SOCK_DGRAM"			# SOCK_SEQPACKET (default) or SOCK_DGRAM?
}

EOF
