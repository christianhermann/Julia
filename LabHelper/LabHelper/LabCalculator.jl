module PreFixCalculator
export calculate_value
# Function to handle Char input
function get_unitPrefix_value(prefix::Union{Char,String})
    # Dictionary to map characters to numeric values
    char_to_num = Dict(
        'Y' => 1e24,  # Yotta
        'Z' => 1e21,  # Zetta
        'E' => 1e18,  # Exa
        'P' => 1e15,  # Peta
        'T' => 1e12,  # Tera
        'G' => 1e9,   # Giga
        'M' => 1e6,   # Mega
        'k' => 1e3,   # Kilo
        'h' => 1e2,   # Hecto
        "" => 1e0,   # Base unit without prefix
        'd' => 1e-1,  # Deci
        'c' => 1e-2,  # Centi
        'm' => 1e-3,  # Milli
        'µ' => 1e-6,  # Micro
        'n' => 1e-9,  # Nano
        'p' => 1e-12, # Pico
        'f' => 1e-15, # Femto
        'a' => 1e-18, # Atto
        'z' => 1e-21, # Zepto
        'y' => 1e-24,  # Yocto
    )
    # Convert single-character strings to Char, except for the empty string
    if prefix isa String && prefix != ""
        prefix = prefix[1]
    end

    # Return the numeric value for the given character
    return char_to_num[prefix]
end

function get_prefixless_value(val::Number, prefix::Union{Char,String})

    prefixless_value = val * get_unitPrefix_value(prefix)
    return prefixless_value
end

function get_prefixed_value(val::Number, prefix::Union{Char,String})

    prefixed_value = val / get_unitPrefix_value(prefix)
    return prefixed_value
end

function calculate_value(val::Number, prefixIn::Union{Char,String}, prefixOut::Union{Char,String})
    prefixless_value = get_prefixless_value(val, prefixIn)
    prefixed_value = get_prefixed_value(prefixless_value, prefixOut)
    return (prefixed_value)
end

end
