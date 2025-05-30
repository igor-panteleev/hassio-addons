# Global parameters
[global]
	dns forwarder = {{ .dns_forwarder }}
	netbios name = {{ .hostname }}
	realm = {{ .realm }}
	server role = active directory domain controller
	workgroup = {{ .domain }}
	idmap_ldb:use rfc2307 = yes
	posix:eadb = /data/private/eadb.tdb

	# Redirect important state to /data (persistent)
	state directory = /data/state
	private dir = /data/private
	cache directory = /data/cache

	# Optional, but avoids runtime files persisting
	lock directory = /run/samba/lock
	pid directory = /run/samba/pid
	ncalrpc dir = /run/samba/ncalrpc

[sysvol]
	path = /data/sysvol
	read only = No

[netlogon]
	path = /data/sysvol/{{ .realm }}/scripts
	read only = No
