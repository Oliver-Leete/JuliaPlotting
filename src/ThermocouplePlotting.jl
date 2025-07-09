using CSV
using DataFrames
using Plots
using Dates

function Thermocouple_Plot(file)
    Thermocouple_Plot = plot(
        title="Temperature/Time Plot",
        xlabel="Time (t - s)",
        ylabel="Temperature (T - °C)",
        legend=:outerright
    )


    csv = CSV.File(file[1])

    DataFrame
    df = DataFrame(csv)

    df = DataFrame(
        "Time (s)" => tosecond.(df[:, 3] - df[1, 3]),
        df[5, 1] => df[:, 4],
        df[1, 7] => df[:, 6],
        df[1, 9] => df[:, 8],
        df[1, 11] => df[:, 10]
    )


    ThermocouplePlot = plot(
        title="Temperature/Time Plot",
        xlabel="Time (s)",
        ylabel="Temperature (°C)",
        legend=:right
    )


    for column in 2:ncol(df)
        plot!(df[:, 1], df[:, column], label="Thermocouple $(column-1)")
    end

    display(plot(ThermocouplePlot))
end
