"""
Wraps the relativeMeltEnthalpy method to allow it to take a string containing
the file path of the CSV data.
"""
function relativeMeltEnthalpy(seriesPath::String; kwargs...)
    return CSV.File(seriesPath) |>
        x -> DataFrame(x)       |>
        x -> relativeMeltEnthalpy(x; kwargs...)
end

"""
Takes a raw dataframe and does all the corections needed to produce a relative
melt enthalpy curve.
"""
function relativeMeltEnthalpy(df::DataFrame; mass=0.2, temp=(150, 170), intTemp=(150, 200))
    return df                          |>
        x -> correctUnits_Speed(x)     |>
        x -> correctUnits_Heatflow(x)  |>
        x -> FilterHeating(x, temp[1]) |>
        x -> flaternMelt(x, temp)      |>
        x -> runSpeedAdjust(x, temp)   |>
        x -> runMassAdjust(x, mass)    |>
        x -> FilterHeating(x, intTemp) |>
        x -> integrateHeatflow(x)      |>
        x -> DPMratio(x)
end

"""
Sets the heatflow at the start of the range (or at the temperature given) to be the new zero for the
heatflow.
"""
function zeroMelt(df::DataFrame)
    df[!, "unsubHF"] = df[!, "unsubHF"] .- df[1, "unsubHF"]
    return df
end
function zeroMelt(df::DataFrame, temp)
    temp1 = findfirst(x -> x > temp, df[!, "sampleTemp"])
    df[!, "unsubHF"] = df[!, "unsubHF"] .- df[temp1, "unsubHF"]
    return df
end

"""
Sets the heatflow at the start of the range (or at the temperature given) to be the new zero for
the heatflow. The same as zeroMelt, but uses the last value for temperature, for use in the cooling
region of DSC plots.
"""
function zeroCool(df::DataFrame)
    df[!, "unsubHF"] = df[!, "unsubHF"] .- df[end, "unsubHF"]
    return df
end

function zeroCool(df::DataFrame, temp)
    temp1 = findfirst(x -> x < temp, df[!, "sampleTemp"])
    df[!, "unsubHF"] = df[!, "unsubHF"] .- df[temp1, "unsubHF"]
    return df
end

"""
Inserts a column into the dataframe that contains a normalised melt enthalpy.
"""
function DPMratio(df::DataFrame)
    maxEnergy = findmax(df[!, "integral"])[1]
    insertcols!(df, ("DPMRatio" => (df[!, "integral"] / maxEnergy)))
    return df
end

"""
Inserts a column into the dataframe that contains a normalised recrystallization enthalpy.
"""
function DPMratioCool(df::DataFrame, meltState)
    maxEnergy = findmin(df[!, "integral"])[1]
    ratio = (meltState * ( df[!, "integral"] / maxEnergy) )
    insertcols!(df, ("DPMRatio" => ratio))
    return df
end

"""
Inserts a column into the dataframe that contains the cumalative integral of
the heatflow (the melt enthalpy).
"""
function integrateHeatflow(df::DataFrame)
    insertcols!(df, ("integral" => cumul_integrate(df[!, "sampleTemp"], df[!, "meltHeat"])))
    return df
end

"""
Inserts a column into the dataframe that contains the reversed cumalative integral of
the heatflow (the recrystallization enthalpy).
"""
function integrateCoolflow(df::DataFrame)
    cumul = reverse(
        cumul_integrate(
            reverse(df[!, "sampleTemp"]),
            reverse(df[!, "meltHeat"])
        )
    )
    insertcols!(df, ("integral" => cumul))
    return df
end

"""
Finds the gradient of the heatflow curve in the temperature range given.
"""
function calcGradMelt(df::DataFrame, temperature::Tuple=(60, 120))
    temp1 = findfirst(x -> x > temperature[1], df[!, "sampleTemp"])
    temp2 = findfirst(x -> x > temperature[2], df[!, "sampleTemp"])
    return (df[temp2, "unsubHF"] - df[temp1, "unsubHF"]) / (temperature[2] - temperature[1])
end
function calcGradCool(df::DataFrame, temperature::Tuple=(60, 120))
    temp1 = findlast(x -> x > temperature[1], df[!, "sampleTemp"])
    temp2 = findlast(x -> x > temperature[2], df[!, "sampleTemp"])
    return (df[temp2, "unsubHF"] - df[temp1, "unsubHF"]) / (temperature[2] - temperature[1])
end

"""
Subtracts the gradient of the pre melt section from the run to produce a 'flat'
curve.
"""
function flaternMelt(df::DataFrame, temperature::Tuple)
    gradient = calcGradMelt(df, temperature)
    df[!, "unsubHF"] = df[!, "unsubHF"] - (df[!, "sampleTemp"] * gradient)
    return df
end

function flaternCool(df::DataFrame, temperature::Tuple)
    gradient = calcGradCool(df, temperature)
    df[!, "unsubHF"] = df[!, "unsubHF"] - (df[!, "sampleTemp"] * gradient)
    return df
end

function calcSPH(df::DataFrame, temperature::Tuple)
    gradient = calcGradMelt(df, temperature)
    temp1 = findlast(x -> x > temperature[1], df[!, "sampleTemp"])
    offset = df[temp1, "unsubHF"] - df[temp1, "sampleTemp"] * gradient
    df[!, "sph"] = [
        ifelse(
            temperature[1] < df[i, "sampleTemp"] < temperature[2],
            offset + df[i, "sampleTemp"] * gradient, df[i, "unsubHF"]) for i in 1:nrow(df)
    ]
    return df
end

function calcSPHCool(df::DataFrame, temperature::Tuple)
    gradient = calcGradCool(df, temperature)
    temp1 = findlast(x -> x > temperature[1], df[!, "sampleTemp"])
    offset = df[temp1, "unsubHF"] - df[temp1, "sampleTemp"] * gradient
    df[!, "sph"] = [
        ifelse(
            temperature[1] < df[i, "sampleTemp"] < temperature[2],
            offset + df[i, "sampleTemp"] * gradient, df[i, "unsubHF"]) for i in 1:nrow(df)
    ]
    return df
end

function subFlatMelt(df::DataFrame)
    df[!, "meltHeat"] = df[!, "unsubHF"] - df[!, "sph"]
    return df
end

"""
Converts the y axis to Joules from Watts by dividing through by the rate of
heating (run speed).
"""
function runSpeedAdjust(df::DataFrame, temperature::Tuple=(30, 150))
    df[!, "unsubHF"] = df[!, "unsubHF"] ./ runSpeed(df, temperature)
    return df
end
function runSpeedAdjust(df::DataFrame, speed::Number)
    df[!, "unsubHF"] = df[!, "unsubHF"] ./ speed
    return df
end

"""
Calculate the speed in degrees per second for the run in the temperature range
given (uses the melting portion of the curve)
"""
function runSpeed(df::DataFrame, temperature::Tuple)
    temp1 = findfirst(x -> x > temperature[1], df[!, "sampleTemp"])
    temp2 = findfirst(x -> x > temperature[2], df[!, "sampleTemp"])
    return speed = (temperature[2] - temperature[1]) / (df[temp2, 1] - df[temp1, 1])
end

"""
Converts the unsubHF to a specific heatflow.
"""
function runMassAdjust(df::DataFrame, mass)
    mass_in_grams = mass/1000
    df[!, "unsubHF"] = df[!, "unsubHF"] ./ mass_in_grams
    return df
end

"""
Converts the units from minutes (the output of the machine) to seconds.
"""
function correctUnits_Speed(df::DataFrame)
    df[!, "time"] = df[!, "time"] .* 60
    return df
end

"""
Converts the units from mw (the output of the machine) to w.
"""
function correctUnits_Heatflow(df::DataFrame)
    df[!, "unsubHF"] = df[!, "unsubHF"] ./ 1000
    df[!, "baseHF"] = df[!, "baseHF"] ./ 1000
    return df
end
