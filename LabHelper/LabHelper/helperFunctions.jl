module helpers
export string_to_float, to_dot_decimal, float_to_string
using Printf

function string_to_float(input::String)::Float64
    try
        return parse(Float64, input)
    catch e
        @error "Failed to convert string to float: $input" e
        return NaN  # Returns NaN (Not a Number) if the input is invalid
    end
end

function to_dot_decimal(input::String)::String
    return replace(input, "," => ".")
end

function float_to_string(value::Float64)::String
    # Check if the value is in the specified range
    if (value < 1000 && value >= 0.001)
        # Print the number as a decimal string
        return @sprintf("%.3F", value)
    else
        # Print the number in scientific notation
        return @sprintf("%.3E", value)
    end
end

end