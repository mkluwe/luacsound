local csd = require 'csound'()

local sine = csd:instr( 'sine' )

sine{ freq = 'f6', start = 0, dur = 1 }
sine{ freq = 'f5', start = 1, dur = 1 }
sine{ freq = 'f4', start = 0.5, dur = 1 }

print( csd:output() )
