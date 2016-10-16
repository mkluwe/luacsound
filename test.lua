local function assertEqual( actual, expected )
    if actual ~= expected then
        io.stdout:write( 'Actual:\n=======\n', actual, '\n',
                         '\nExpected:\n=========\n', expected )
        os.exit( 1 )
    end
end

local csound = require 'csound'

local csd = csound()

local sine = csd:instr( 'sine' )

sine{ freq = 'f6', start = 0, dur = 1 }
sine{ freq = 'f5', start = 1, dur = 1 }
sine{ freq = 'f4', start = 0.5, dur = 1 }

local output = csd:output()

assertEqual( output, [[
<CsoundSynthesizer>
<CsOptions>
-A -o stdout -f
</CsOptions>
<CsInstruments>
instr 1
aSin      poscil    1, p4
          out       aSin
endin
</CsInstruments>
<CsScore>
i 1 0 1 1396.912925732 
i 1 1 1 698.45646286601 
i 1 0.5 1 349.228231433 
</CsScore>
</CsoundSynthesizer>
]] )
