require 'faye'
faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 45)
Faye::WebSocket.load_adapter('thin')
run faye_server
