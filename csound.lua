local csound = {}

local instr = {}

csound.start = function()
    print [[
<CsoundSynthesizer>
<CsOptions>
-o stdout
</CsOptions>
<CsInstruments>]]
end

csound.stop = function()
    print [[
</CsScore>
</CsoundSynthesizer>]]
end

csound.play = function()
    print [[
</CsInstruments>
<CsScore>]]
end    

csound.instr = function( name )
    local instr_number = #instr + 1 
    instr[ instr_number ] = name
    print( 'instr ' .. tostring( instr_number ) )
    local f = assert( io.open( name .. '.orc' ) )
    print( f:read'*a' )
    print( 'endin' )
    return function( start, duration, ... )
        io.stdout:write(
            'i ',
            tostring( instr_number ), ' ',
            tostring( start ), ' ',
            tostring( duration ),
            '\n'
        )
    end
end

return csound
