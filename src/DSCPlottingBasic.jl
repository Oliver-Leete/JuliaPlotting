using CSV
using DataFrames
using Plots


"""
    PlotDSCProfile(seriesPath)

Adds a series of temperature vs time to the current active plot using data from a csv given in the seriesPath variable, standard plot kwargs are accepted for editing this plot.
"""
function PlotDSCProfile!(seriesPath, binNum=1; kwargs...)
  DF = CSV.File(seriesPath) |> DataFrame

  plot!(DF[1:binNum:end,1] .* 60, DF[1:binNum:end,5],
        xlabel="Time (s)", ylabel="Temperature (°C)",
        size=plotSize; kwargs...)
end

"""
    PlotDSC!(seriesPath)

Adds a series of heatflow vs temperature to the current active plot using data from a csv given in the seriesPath variable, standard plot kwargs are accepted for editing this plot
"""
function PlotDSC!(seriesPath, binNum=10; kwargs...)
  DF = CSV.File(seriesPath) |> DataFrame

  filter!(row -> row[5] > 35, DF)
  DF[:, 2] = DF[:,2] .- DF[1,2]

  plot!(DF[1:binNum:end,5], DF[1:binNum:end,2],
        xlabel="Temperature (°C)", ylabel="Heat Flow (mW)",
        size=plotSize; kwargs...)
end

"""
    PlotDSCTime!(seriesPath)

Adds a series of heatflow vs time to the current active plot using data from a csv given in the seriesPath variable, standard plot kwargs are accepted for editing this plot
"""
function PlotDSCTime!(seriesPath, binNum=1; kwargs...)
  Df = CSV.File(seriesPath) |> DataFrame

  plot!(Df[1:binNum:end,1] .* 60, Df[1:binNum:end,2],
        xlabel="Time (s)", ylabel="Heat Flow (mW)",
        size=plotSize; kwargs...)
end
