# Global parameters
[global]
	dns forwarder = {{ .dns_forwarder }}
	netbios name = {{ .hostname }}
	realm = {{ .realm }}
	server role = active directory domain controller
	workgroup = {{ .domain }}
	idmap_ldb:use rfc2307 = yes
	posix:eadb = {{ .data_dir }}/private/eadb.tdb

	# Redirect important state to /data (persistent)
	state directory = {{ .data_dir }}/state
	private dir = {{ .data_dir }}/private
	cache directory = {{ .data_dir }}/cache

	# Optional, but avoids runtime files persisting
	lock directory = /run/samba/lock
	pid directory = /run/samba/pid
	ncalrpc dir = /run/samba/ncalrpc

[sysvol]
	path = {{ .data_dir }}/sysvol
	read only = No

[netlogon]
	path = {{ .data_dir }}/sysvol/{{ .realm }}/scripts
	read only = No
