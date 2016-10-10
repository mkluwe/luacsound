local csound = {}

local instr_param = {
    'start',
    'dur',
    'freq',
}

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

local pitch = {}
local notes = {
    'c', 'c#', 'd', 'd#', 'e', 'f', 'f#', 'g', 'g#', 'a', 'a#', 'b'
}
for i = 1, #notes do
    pitch[ notes[ i ] ] = {
        [4] = 440.0 * math.pow( 2.0, ( i - 10.0 ) / 12.0 )
    }
end
for _, v in pairs( pitch ) do
    for i = 0, 10 do
        v[ i ] = v[ 4 ] * math.pow( 2.0, i - 4 )
    end
end

local function convert_pitch( freq )
    if type( freq ) == 'number' then
        return freq
    end
    local note, octave = freq:match( '(%D+)(%d+)' )
    return pitch[ note ][ tonumber( octave ) ]
end

csound.instr = function( name )
    local instr_number = #instr + 1 
    instr[ instr_number ] = name
    print( 'instr ' .. tostring( instr_number ) )
    local f = assert( io.open( name .. '.orc' ) )
    io.stdout:write( f:read'*a' )
    print( 'endin' )
    return function( parm )
        io.stdout:write( 'i ', tostring( instr_number ), ' ' )
        parm.freq = convert_pitch( parm.freq )
        local output_parm = {}
        for i = 1, #instr_param do
            local p = parm[ instr_param[ i ] ]
            io.stdout:write( p and tonumber( p ) or '0', ' ' )
        end
        io.stdout:write( '\n' )
    end
end

return csound
