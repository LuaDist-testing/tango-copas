About
=======

tango is a small, simple and customizable RPC (remote procedure call)
module for Lua.

Its main features are:

* a generic transparent [proxy](https://github.com/lipp/tango/blob/master/tango/proxy.lua) for call invocations
* a generic [dispatch](https://github.com/lipp/tango/blob/master/tango/dispatch.lua) routine for servers
* several server implementations for different protocols, message formats and event/io
frameworks, further called backends
* several client implementations for different protocols and message formats


Backends included
---------------------

* copas  
* [lua-zmq](https://github.com/Neopallium/lua-zmq)
* [lua-ev](https://github.com/brimworks/lua-ev)

Example (with copas backend)
--------------------------------
The greet server code 

```lua
require'tango.server.copas_socket'
greet = function(...)
          print(...)
        end         
tango.server.copas_socket.loop{
  port = 12345
}
```

The client code calling the remote server function `greet`
      
```lua
require'tango.client.socket'
local proxy = tango.client.socket.connect{
   address = 'localhost',
   port = 12345
}
proxy.greet('Hello','Horst')
```

Since the server exposes the global table `_G` per default, the client may even
directly call `print`,let the server sleep a bit remotely
(`os.execute`) or calc some stuff (`math.sqrt`).

```lua
proxy.print('I','call','print','myself')         
proxy.os.execute('sleep 1')
proxy.math.sqrt(4)
```

One can limit the server exposed functions by specifying a `functab`
like this (to expose only methods of he math table/module):

```lua
require'tango.server.copas_socket'
tango.server.copas_socket.loop{
  port = 12345,
  functab = math
}
```

As the global table `_G` is not available any more, the client can
only call methods from the math module:

```lua
proxy.sqrt(4)
```


Tests
------

You can run test by the following sh call in the project root directory

      ./test.lua

Client/Server compatibilities
-----------------------------

<table border="1">               
        <tr>
                <th></th><th>tango.client.socket</th><th>tango.client.zmq</th>
        </tr>
        <tr>
                <th>tango.server.copas_socket</th><th>X</th><th></th>
        </tr>
        <tr>
                <th>tango.server.ev_socket</th><th>X</th><th></th>
        </tr>
        <tr>
                <th>tango.server.zmq</th><th></th><th>X</th>
        </tr>
</table>


Serialization
-------------
tango provides a default (lua-only) table serialization which should
meet most common use cases.

Anyhow, the table serialization is neither exceedingly fast nor
compact in output or memory consumption. If this is a problem for your application, you can
customize the serialization by assigning your serialize/unserialize
methods to the clients and servers respectively.

Socket client with customized serialization:

```lua
local cjson = require'cjson'
local connect = require'tango.client.socket'.connect
local client = connect{
   serialize = cjson.encode,
   unserialize = cjson.decode}
```

Copas socket server with customized serialization:

```lua
local cjson = require'cjson'
local server = require'tango.server.copas_socket'
server.loop{
   serialize = cjson.encode,
   unserialize = cjson.decode}
```

Some alternatives are:

* [lua-marshal](https://github.com/richardhundt/lua-marshal)
* [lua-cjson](http://www.kyne.com.au/~mark/software/lua-cjson.php)
* [luabins](https://github.com/agladysh/luabins)
* [luatexts](https://github.com/agladysh/luatexts)

Requirements
------------

The requirements depend on the desired i/o backend, see the
corresponding [rockspecs](https://github.com/lipp/tango/tree/master/rockspecs) for details.


Installation
-------------
With LuaRocks > 2.0.4.1:

     $ sudo luarocks install https://raw.github.com/lipp/tango/master/rockspecs/tango-complete-0.1-1.rockspec

The complete package require lua-zmq and lua-ev. If you don't plan to
use them and stick to copas, use this:
  
     $ sudo luarocks install https://raw.github.com/lipp/tango/master/rockspecs/tango-copas-0.1-1.rockspec

Note: luarocks require luasec for doing https requests.

     $ sudo luarocks install luasec
