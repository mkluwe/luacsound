local csound = {}

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

csound.read_instrument = function( self, name )
    local f = assert( io.open( name .. '.orc' ) )
    local text = f:read( '*a' )
    local instrument = {}
    self.instruments[ #self.instruments + 1 ] = instrument
    instrument.number = #self.instruments 
    local output = {}
    output[ #output + 1 ] = 'instr '
    output[ #output + 1 ] = instrument.number .. '\n'
    output[ #output + 1 ] = text
    output[ #output + 1 ] = 'endin\n'
    output = table.concat( output, '' )
    instrument.param = { 'number', 'start', 'dur',
        number = 1, start = 2, dur = 3 }
    for param in text:gmatch( '%$(%w+)' ) do
        if not instrument.param[ param ] then
            instrument.param[ #instrument.param + 1 ] = param
            instrument.param[ param ] = #instrument.param
        end
    end
    instrument.output = output:gsub( '%$(%w+)', function( param )
        return ( 'p%d' ):format( instrument.param[ param ] )
    end )
    return instrument
end

csound.instr = function( self, name )
    local instrument = self:read_instrument( name )
    local fun
    local param = {}
    fun = function( next_param )
        local output = { 'i ', instrument.number, ' ' }
        for k, v in pairs( next_param ) do
            param[ k ] = v
        end
        param.freq = convert_pitch( param.freq )
        for i = 2, #instrument.param do
            local param_name = instrument.param[ i ]
            local p = param[ param_name ]
            if p then
                output[ #output + 1 ] = tostring( p )
                instrument[ param_name ] = p
            else
                local carry_param = instrument[ param_name ]
                carry_param = carry_param and tostring( carry_param )
                output[ #output + 1 ] = carry_param or '0'
            end
            output[ #output + 1 ] = ' '
        end
        output[ #output ] = '\n'
        self.score[ #self.score + 1 ] = table.concat( output, '' )
        return fun
    end
    return fun
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
