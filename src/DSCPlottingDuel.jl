"""
    DSC_HeatflowTempTimePlot!(seriesPath, timeRange, heatRange, tempRange)

WIP, Adds a duel axis series to the current active plot, plotting temperature and heatflow against time.
"""
function DSC_HeatflowTempTimePlot!(seriesPath, timeRange, heatRange, tempRange; kwargs...)
  df = CSV.File(seriesPath) |> DataFrame

  filter!(row -> timeRange[2] > row[1]*60 > timeRange[1], df)
  df[:, 2] = df[:,2] .- df[1,2]

  plot!(df[:,1] .* 60, df[:,2], xlabel="Time (s)",
        xlims=timeRange, ylims=heatRange; kwargs...)

  plot!(twinx(), df[:,1] .* 60, df[:,5],
        xlabel="Time (s)", ylabel="Temperature (°C)",
        size=plotSize, xlims=timeRange, ylims=tempRange; kwargs...)

end
