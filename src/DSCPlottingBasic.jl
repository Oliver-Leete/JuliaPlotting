function pathToDF(path)
    return CSV.File(path) |> 
    DataFrame |> 
    x -> DataFrame(
        time = x[:,1],
        unsubHF = x[:,2],
        baseHF = x[:,3],
        programTemp = x[:,4],
        sampleTemp = x[:,5],
        gasFlow = x[:,6],
        HFcal = x[:,7],
        unCorrectHF = x[:,8],
    )
end

function keepNth(df, skipNum)
    return mapcols(x -> (x[1:skipNum:end]), df)
end

"""
    getExtrema(data, roundTo)

Find the maximum and minimum extrema of a set of data, rounded to the nearest multiple of roundTo.

"""
function getExtrema(data, roundTo)
    (minVal, maxVal) = extrema(data)

    maxRound = ceil(typeof(roundTo), maxVal/roundTo) * roundTo
    minRound = floor(typeof(roundTo), minVal/roundTo) * roundTo

    return maxRound, minRound
end

"""
    PlotDSCProfile(seriesPath)

Adds a series of temperature vs time to the current active plot using data from a csv given in the
seriesPath variable, standard plot kwargs are accepted for editing this plot.

"""
# function PlotDSCProfile!(seriesPath, binNum=1; kwargs...)
#   DF = CSV.File(seriesPath) |> DataFrame

#   plot!(DF[1:binNum:end,1] .* 60, DF[1:binNum:end,5],
#         xlabel="Time (s)", ylabel="Temperature (°C)",
#         size=plotSize; kwargs...)
# end

"""
    PlotDSC!(seriesPath)

Adds a series of heatflow vs temperature to the current active plot using data from a csv given in
the seriesPath variable, standard plot kwargs are accepted for editing this plot

"""
# function PlotDSC!(seriesPath, binNum=10; kwargs...)
#   DF = CSV.File(seriesPath) |> DataFrame
# 	PlotDSC!(DF, binNum; kwargs...)
# end

# function PlotDSC!(DF::DataFrame, binNum=10; kwargs...)
#   filter!(row -> row[5] > 35, DF)
#   DF[:, 2] = DF[:,2] .- DF[1,2]

#   plot!(DF[1:binNum:end,5], DF[1:binNum:end,2],
#         xlabel="Temperature (°C)", ylabel="Heat Flow (mW)",
#         size=plotSize; kwargs...)
# end

"""
    PlotDSCTime!(seriesPath)

Adds a series of heatflow vs time to the current active plot using data from a csv given in the
seriesPath variable, standard plot kwargs are accepted for editing this plot

"""
# function PlotDSCTime!(seriesPath, binNum=1; kwargs...)
#   Df = CSV.File(seriesPath) |> DataFrame

#   plot!(Df[1:binNum:end,1] .* 60, Df[1:binNum:end,2],
#         xlabel="Time (s)", ylabel="Heat Flow (mW)",
#         size=plotSize; kwargs...)
# end
