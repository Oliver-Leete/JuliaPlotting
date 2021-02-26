using CSV
using DataFrames
using Plots
using Statistics

function PlotTensileStressStrain!(path, σ_drop = 0.3; kwargs...)
  DF = CSV.File(path, header=["Force","Displacment","σ","ε̇", "Time"], datarow=4, footerskip=1) |> DataFrame

  insertcols!(DF, 6, "ε" => (DF[:, "ε̇"] .- DF[1, "ε̇"]))

  # Create vectors from dataframe ready to plot
  ε⃗ = DF[:, "ε̇"]
  σ⃗ = DF[:, "σ"]

  # Trim vectors to breaking point
  for line in 1:length(σ⃗)
    if σ⃗[line+1] <= σ⃗[line] - σ_drop
      ε⃗ = ε⃗[1:line+1]
      σ⃗ = σ⃗[1:line+1]
      break
    end
  end

  plot!(ε⃗, σ⃗, xlabel="Strain (ε - %)",
  ylabel="Stress (σ - MPa)",
  legend =:outerright; kwargs...)
end


"""

"""
function PlotStressBar!(dataset::Array{String,2}; kwargs...)
  σavg = []
  σstd = []

  for series in 1:length(dataset)
    series = dataset[series,:]
    σmax = []

    for run in series
      DF = CSV.File(run, header=["Force","Displacment","σ","ε̇", "Time"], datarow=4, footerskip=1) |> DataFrame
      push!(σmax, findmax(DF[!,σ])[1])
    end

    push!(σavg, mean(σmax))
    push!(σavg, std(σmax))
  end

  bar!(σavg, yerr=σstd; kwargs...)
end
