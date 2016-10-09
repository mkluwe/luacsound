local csound = require 'csound'
local instr = csound.instr

csound.start()

local sine = instr( 'sine' )

csound.play()

sine{ freq = 440, start = 0, dur = 1 }
sine{ freq = 220, start = 1, dur = 1 }

csound.stop()
