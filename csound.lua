local csound = {}

local instr_param = {
    'start',
    'dur',
    'freq',
}

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

csound.instr = function( self, name )
    local instr_number = #self.instruments + 1 
    local instrument = {}
    self.instruments[ instr_number ] = instrument
    local output = {
        'instr ' .. tostring( instr_number ) .. '\n'
    }
    local f = assert( io.open( name .. '.orc' ) )
    output[ #output + 1 ] = f:read( 'a' )
    output[ #output + 1 ] = 'endin\n'
    instrument.output = table.concat( output, '' )
    return function( parm )
        local output = { 'i ', tostring( instr_number ), ' ' }
        parm.freq = convert_pitch( parm.freq )
        local output_parm = {}
        for i = 1, #instr_param do
            local p = parm[ instr_param[ i ] ]
            output[ #output + 1 ] = p and tonumber( p ) or '0'
            output[ #output + 1 ] = ' '
        end
        output[ #output + 1 ] = '\n'
        self.score[ #self.score + 1 ] = table.concat( output, '' )
    end
end

csound.output = function( self )
    local output = {
    [[
<CsoundSynthesizer>
<CsOptions>
-A -o stdout -f
</CsOptions>
<CsInstruments>
]]
    }
    for i = 1, #self.instruments do
        output[ #output + 1 ] = self.instruments[ i ].output
    end
    output[ #output + 1 ] = [[
</CsInstruments>
<CsScore>
]]
    for i = 1, #self.score do
        output[ #output + 1 ] = self.score[ i ]
    end
    output[ #output + 1 ] = [[
</CsScore>
</CsoundSynthesizer>
]]
    return table.concat( output, '' )
end

return function()
    return setmetatable( {
        instruments = {},
        score = {},
    }, {
        __index = csound
    } )
end
