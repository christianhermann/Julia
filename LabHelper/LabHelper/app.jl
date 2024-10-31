module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using GenieFramework
@genietools

include("LabCalculator.jl")
using .PreFixCalculator
include("helperFunctions.jl")
using .helpers
# == Code import ==
# add your data analysis code here or in the lib folder. Code in lib/ will be
# automatically loaded 

# == Reactive code ==
# add reactive code to make the UI interactive
@app begin
    # == Reactive variables ==
    # reactive variables exist in both the Julia backend and the browser with two-way synchronization
    # @out variables can only be modified by the backend
    # @in variables can be modified by both the backend and the browser
    # variables must be initialized with constant values, or variables defined outside of the @app block
    @out tab_ids =  ["tab_1", "tab_2", "tab_3"]
    @out tab_labels = ["Unit Calculator", "Scooters", "Bikes"]
    @in selected_tab =  "tab_1"
    
    @out prefix_options = [
        'Y', 'Z', 'E', 'P', 'T', 
        'G', 'M', 'k', 'h', "", 
        'd', 'c', 'm', 'µ', 'n', 
        'p', 'f', 'a', 'z', 'y'
    ]
    @in input_value = "0"
    @out output_value = "0"
    @in selected_prefix_input = ""
    @in selected_prefix_output = ""

    # == Reactive handlers ==
    # reactive handlers watch a variable and execute a block of code when
    # its value changes
    @onchange input_value begin
        value = to_dot_decimal(input_value)
        value = calculate_value(string_to_float(value), selected_prefix_input, selected_prefix_output)
        output_value = float_to_string(value)
    end
    @onchange selected_prefix_input begin
        value = to_dot_decimal(input_value)
        value = calculate_value(string_to_float(value), selected_prefix_input, selected_prefix_output)
        output_value = float_to_string(value)
    end
    @onchange selected_prefix_output begin
        value = to_dot_decimal(input_value)
        value = calculate_value(string_to_float(value), selected_prefix_input, selected_prefix_output)
        output_value = float_to_string(value)
    end
end



# == Pages ==
# register a new route and the page that will be loaded on access
@page("/", "app.jl.html")
end

# == Advanced features ==
#=
- The @private macro defines a reactive variable that is not sent to the browser. 
This is useful for storing data that is unique to each user session but is not needed
in the UI.
    @private table = DataFrame(a = 1:10, b = 10:19, c = 20:29)

=#
