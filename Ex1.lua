local csound = require 'csound'
local instr = csound.instr

csound.start()

local sine = instr( 'sine' )

csound.play()

sine{ freq = 'f6', start = 0, dur = 1 }
sine{ freq = 'f5', start = 1, dur = 1 }
sine{ freq = 'f4', start = 0.5, dur = 1 }

csound.stop()
