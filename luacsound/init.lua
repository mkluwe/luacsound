local csound = {}

-- standard scale
local scale = {
    [ 'cb' ] = -1,
    [ 'c'  ] =  0,
    [ 'c#' ] =  1,
    [ 'db' ] =  1,
    [ 'd'  ] =  2,
    [ 'd#' ] =  3,
    [ 'eb' ] =  3,
    [ 'e'  ] =  4,
    [ 'e#' ] =  5,
    [ 'fb' ] =  4,
    [ 'f'  ] =  5,
    [ 'f#' ] =  6,
    [ 'gb' ] =  6,
    [ 'g'  ] =  7,
    [ 'g#' ] =  8,
    [ 'ab' ] =  8,
    [ 'a'  ] =  9,
    [ 'a#' ] = 10,
    [ 'bb' ] = 10,
    [ 'b'  ] = 11,
    [ 'b#' ] = 12,
}

local pitch = {}

-- convert a given note to a pitch in standard twelve-tone equal temperament
-- tuning
local function convert_pitch( note )
    if type( note ) == 'number' then return note end
    local freq = pitch[ note ]
    if freq then return freq end
    local name, octave = note:match( '(%D+)(%d+)' )
    octave = tonumber( octave )
    freq = 440.0 * math.pow( 2.0, octave - 5 + ( scale[ name ] + 3 ) / 12 )
    pitch[ note ] = freq
    return freq
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
