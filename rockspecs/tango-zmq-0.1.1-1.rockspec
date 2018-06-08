package = 'tango-zmq'
version = '0.1.1-1'
source = {
   url = 'git://github.com/lipp/tango.git',
   branch = '0.1.1'
}
description = {
   summary = 'Remote procedure calls (RPC) for Lua.',
   homepage = 'http://github.com/lipp/tango',
   license = 'MIT/X11'
}
dependencies = {
   'lua >= 5.1',
   'lua-zmq >= 1.0'
}
build = {
   type = 'builtin',
   modules = {
      ['tango.proxy'] = 'tango/proxy.lua',
      ['tango.dispatch'] = 'tango/dispatch.lua',
      ['tango.utils.serialization'] = 'tango/utils/serialization.lua',
      ['tango.client.zmq'] = 'tango/client/zmq.lua',
      ['tango.server.zmq'] = 'tango/server/zmq.lua'
   }
}
