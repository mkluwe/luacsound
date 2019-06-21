# luacsound

*luacsound* is a simple [Lua](http://www.lua.org/) module for generating
[Csound](http://csound.github.io/) files.

If you are interested in algorithmic composing or simply tired of writing Csound
scores "by hand", you might give this a try.

  - *luacsound* enables you to write a Csound score as a Lua program,

  - You can use Csound instruments as Lua functions and it

  - outputs the result of the program as a standard `.csd` file (Csound's XML
    format).

## Installation

Use [LuaRocks](https://luarocks.org/) as a package manager and install using

```sh
luarocks --local install luacsound
```

Omit the `--local` to perform a global install.

Alternatively, a manual install can be accomplished by copying the `luacsound`
directory (the one containing the `init.lua` file) where it can be found by
`require()`, e.g. some directory in `LUA_PATH`. See the Lua reference manual for
details.

## Usage

The following example loads the module, creates a new piece of output, loads an
instrument (expecting it to be defined in file `sine.orc`) and uses the intrument
for a few notes, using the standard parameters. Finally, the `.csd` file is printed
that could be processed by `csound`.

```lua
local csound = require 'luacsound'

local csd = csound()

local sine = csd:instr( 'sine' )

sine{ freq = 'f6', start = 0, dur = 1, vol = 2 }
sine{ freq = 'f5', start = 1, dur = 1, vol = 2 }
sine{ freq = 'f4', start = 0.5, dur = 1, vol = 2 }

print( csd:output() )
```

## Contributing

This is mostly a private fun project. However, pull requests are welcome.

## License

Code is released under the [MIT License](LICENSE).
