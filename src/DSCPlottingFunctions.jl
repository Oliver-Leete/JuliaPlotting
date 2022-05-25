function profilePlotter(fig, run; kwargs...)
    df = pathToDF(run)|>
    x -> keepNth(x, 5)|>
    x -> correctUnits_Speed(x)
    plot!(fig, df[!,"time"], df[!, "programTemp"],
        size=plotSize,
        xlabel="Time (s)", ylabel="Temperature (\$^\\circ\$C)"
        ; kwargs...
    )
end

function regPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)            |>
    x -> keepNth(x, 5)            |>
    x -> correctUnits_Speed(x)    |>
    x -> correctUnits_Heatflow(x) |>
    x -> runMassAdjust(x, mass)   |>
    x -> runSpeedAdjust(x, speed)
    plot!(fig, df[!,"sampleTemp"], df[!, "unsubHF"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Total Heat Flow (J/g\$^\\circ\$C)",
        legend=:topleft; kwargs...
    )
end

function meltPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)                |>
    x -> keepNth(x, 5)                |>
    x -> correctUnits_Speed(x)        |>
    x -> correctUnits_Heatflow(x)     |>
    x -> runSpeedAdjust(x, speed)     |>
    x -> runMassAdjust(x, mass)       |>
    x -> FilterHeating(x, (160,200))  |>
    x -> flaternMelt(x, (160, 198))   |>
    x -> zeroMelt(x, 160)
    plot!(fig, df[!,"sampleTemp"], df[!, "unsubHF"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Total Heat Flow (J/g\$^\\circ\$C)",
        legend=:topleft; kwargs...
    )
end

function meltTimePlotter(fig, run, mass; kwargs...)
    df = pathToDF(run)                |>
    x -> keepNth(x, 5)                |>
    x -> correctUnits_Speed(x)        |>
    x -> correctUnits_Heatflow(x)     |>
    x -> runMassAdjust(x, mass)       |>
    x -> FilterHeating(x, (160, 200)) |>
    x -> flaternMelt(x, (160, 200))   |>
    x -> zeroMelt(x, 160)
    plot!(fig, df[!,"time"], df[!, "unsubHF"],
        size=plotSize,
        xlabel="Time (s)", ylabel="Specific Total Heat Flow (J/g\$^\\circ\$C)",
        legend=:topright; kwargs...
    )
end

function coolPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)                |>
    x -> keepNth(x, 5)                |>
    x -> correctUnits_Speed(x)        |>
    x -> correctUnits_Heatflow(x)     |>
    x -> runSpeedAdjust(x, speed)     |>
    x -> runMassAdjust(x, mass)       |>
    x -> FilterCooling(x, (80, 170))  |>
    x -> flaternCool(x, (80, 140))    |>
    x -> zeroCool(x, 80)
    plot!(fig, df[!,"sampleTemp"], df[!, "unsubHF"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Total Heat Flow (J/g\$^\\circ\$C)",
        legend=:bottomleft; kwargs...
    )
end

function unsubPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)                |>
    x -> keepNth(x, 5)                |>
    x -> correctUnits_Speed(x)        |>
    x -> correctUnits_Heatflow(x)     |>
    x -> runSpeedAdjust(x, speed)     |>
    x -> runMassAdjust(x, mass)       |>
    x -> FilterHeating(x, (30, 200))
    plot!(fig, df[!,"sampleTemp"], df[!, "unsubHF"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Total Heat Flow (J/g\$^\\circ\$C)",
        legend=:topleft; kwargs...
    )
end

function spheatPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)                |>
    x -> keepNth(x, 5)                |>
    x -> correctUnits_Speed(x)        |>
    x -> correctUnits_Heatflow(x)     |>
    x -> runSpeedAdjust(x, speed)     |>
    x -> runMassAdjust(x, mass)       |>
    x -> FilterHeating(x, (30, 200))  |>
    x -> calcSPH(x, (160,190))
    plot!(fig, df[!,"sampleTemp"], df[!, "sph"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Heat Capacity (J/g\$^\\circ\$C)",
        legend=:topleft; kwargs...
    )
end

function heatOfMeltPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)              |>
    x -> keepNth(x, 5)              |>
    x -> correctUnits_Speed(x)      |>
    x -> correctUnits_Heatflow(x)   |>
    x -> runSpeedAdjust(x, speed)   |>
    x -> runMassAdjust(x, mass)     |>
    x -> FilterHeating(x, (30,200)) |>
    x -> calcSPH(x, (160,190))      |>
    x -> subFlatMelt(x)

    plot!(fig, df[!,"sampleTemp"], df[!, "meltHeat"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Specific Heat of Melt (J/g\$^\\circ\$C)",
        legend=:topleft; kwargs...
    )
end

function energyPlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)              |>
    x -> keepNth(x, 5)              |>
    x -> correctUnits_Speed(x)      |>
    x -> correctUnits_Heatflow(x)   |>
    x -> runSpeedAdjust(x, speed)   |>
    x -> runMassAdjust(x, mass)     |>
    x -> FilterHeating(x, (30,200)) |>
    x -> calcSPH(x, (160,190))      |>
    x -> subFlatMelt(x)             |>
    x -> integrateHeatflow(x)
    plot!(fig, df[!,"sampleTemp"], df[!, "integral"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Cumalative Specific Heat of Melt (J/g)",
        legend=:topleft; kwargs...
    )
end

function meltStatePlotter(fig, run, mass, speed; kwargs...)
    df = pathToDF(run)               |>
    x -> keepNth(x, 5)               |>
    x -> correctUnits_Speed(x)       |>
    x -> correctUnits_Heatflow(x)    |>
    x -> runSpeedAdjust(x, speed)    |>
    x -> runMassAdjust(x, mass)      |>
    x -> FilterHeating(x, (30,200))  |>
    x -> calcSPH(x, (160,190))       |>
    x -> subFlatMelt(x)              |>
    x -> integrateHeatflow(x)        |>
    x -> FilterHeating(x, (160,190)) |>
    x -> DPMratio(x)
    plot!(fig, df[!,"sampleTemp"], df[!, "DPMRatio"],
        size=plotSize,
        xlabel="Temperature (\$^\\circ\$C)", ylabel="Melt State",
        legend=:topleft; kwargs...
    )
end
