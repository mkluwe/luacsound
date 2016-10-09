local csound = {}

local instr_param = {
    'start',
    'dur',
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

csound.instr = function( name )
    local instr_number = #instr + 1 
    instr[ instr_number ] = name
    print( 'instr ' .. tostring( instr_number ) )
    local f = assert( io.open( name .. '.orc' ) )
    io.stdout:write( f:read'*a' )
    print( 'endin' )
    return function( parm )
        io.stdout:write( 'i ', tostring( instr_number ), ' ' )
        local output_parm = {}
        for i = 1, #instr_param do
            local p = parm[ instr_param[ i ] ]
            io.stdout:write( p and tonumber( p ) or 0, ' ' )
        end
        io.stdout:write( '\n' )
    end
end

return csound
