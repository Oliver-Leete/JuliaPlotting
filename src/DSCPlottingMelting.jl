using CSV
using DataFrames
using Plots

"""
    PlotDSCHeatingTemp!(seriesPath, temperature, runSpeed = 0.0)

Adds a series of heatflow vs temperature for the heating region to the current active plot using data from a csv given in the seriesPath variable.

This plot is cropped to the temperature range given (or if only one temperature is given it takes the range between that and the maximum temperature) on the heating part of the curve. If a value is given for the run speed it will normalise the plot for that speed. Standard plot kwargs are accepted for editing this plot.
"""
function PlotDSCHeatingTemp!(seriesPath, temperature, runSpeed=0.0, binNum=1; kwargs...)
    DF = CSV.File(seriesPath) |> DataFrame

    DF = FilterHeating(DF, temperature)
    DF[:, 2] = DF[:,2] .- DF[1,2]

    plot!(DF[1:binNum:end,5], (runSpeed == 0) ? DF[1:binNum:end,2] : (DF[1:binNum:end,2] / (runSpeed*60)),
        xlabel="Temperature (°C)", ylabel=(runSpeed == 0) ? "Heat Flow (mW)" : "Energy (J/°C)",
        size=plotSize; kwargs...)
end

"""
    PlotDSCHeatingTime!(seriesPath, temperature)

Adds a series of heatflow vs time for the heating region to the current active plot using data from a csv given in the seriesPath variable.

This plot is cropped to the temperature range given (or if only one temperature is given it takes the range between that and the maximum temperature) on the heating part of the curve. Standard plot kwargs are accepted for editing this plot.
"""
function PlotDSCHeatingTime!(seriesPath, temperature, binNum=1; kwargs...)
    DF = CSV.File(seriesPath) |> DataFrame

    DF = FilterHeating(DF, temperature)
    DF[:, 1] = DF[:,1] .- DF[1,1]
    DF[:, 2] = DF[:,2] .- DF[1,2]

    plot!(DF[1:binNum:end,1] .* 60, DF[1:binNum:end,2],
        xlabel="Time (s)", ylabel="Heat Flow (mW)",
        size=plotSize; kwargs...)
end
