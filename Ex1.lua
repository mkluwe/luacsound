local csound = require 'csound'
local instr = csound.instr

csound.start()

local sine = instr( 'sine' )

csound.play()

sine( 0, 1 )

csound.stop()
