-- use local package; you don't have to use this if the `luacsound` is
-- installed
package.path = package.path .. ';../?/init.lua'

local csd = require 'luacsound'()

local sine = csd:instr( 'sine' )

sine{ freq = 'f6', start = 0, dur = 1, vol = 2 }
sine{ freq = 'f5', start = 1, dur = 1, vol = 2 }
sine{ freq = 'f4', start = 0.5, dur = 1, vol = 2 }

print( csd:output() )
