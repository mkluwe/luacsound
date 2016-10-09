local csound = require 'csound'
local instr = csound.instr

csound.start()

local sine = instr( 'sine' )

csound.play()

sine{ start = 0, dur = 1 }

csound.stop()
