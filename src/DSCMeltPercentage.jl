"""
Wraps the relativeMeltEnthalpy method to allow it to take a string containing
the file path of the CSV data.
"""
function relativeMeltEnthalpy(seriesPath::String; kwargs...)
  return CSV.File(seriesPath) |>
  x -> DataFrame(x) |>
  x -> relativeMeltEnthalpy(x; kwargs...)
end

"""
Takes a raw dataframe and does all the corections needed to produce a relative
melt enthalpy curve.
"""
function relativeMeltEnthalpy(DF::DataFrame; mass=0.2, temp=(150,170), intTemp=(150, 200))
  return DF |>
  x -> correctUnits_Speed(x) |>
  x -> correctUnits_Heatflow(x) |>
  x -> FilterHeating(x, temp[1]) |>
  x -> flaternMelt(x, temp) |>
  x -> runSpeedAdjust(x, temp) |>
  x -> runMassAdjust(x, mass) |>
  x -> FilterHeating(x, intTemp) |>
  x -> integrateHeatflow(x) |>
  x -> DPMratio(x)
end

"""
Inserts a column into hte dataframe that contains a normalised melt enthalpy.
"""
function DPMratio(DF::DataFrame)
  maxEnergy = findmax(DF[:,9])[1]
  insertcols!(DF, 10, (:DPMRatio => (DF[:,9]/maxEnergy)))
  return DF
end

"""
Inserts a column into the dataframe that contains the cumalative integral of
the heatflow (the melt enthalpy).  
"""
function integrateHeatflow(DF::DataFrame)
  insertcols!(DF, 9, (:Integral => cumul_integrate(DF[:,5], DF[:,2])))
  return DF
end

"""
Finds the gradient of the heatflow curve in the temperature range given.
"""
function calcGradient(DF::DataFrame, temperature::Tuple = (60, 120))
  temp1 = findfirst(x -> x>temperature[1], DF[:,5])
  temp2 = findfirst(x -> x>temperature[2], DF[:,5])
  return gradient = (DF[temp2, 2] - DF[temp1, 2])/(temperature[2] - temperature[1])
end

"""
Subtracts the gradient of the pre melt section from the run to produce a 'flat'
curve.
"""
function flaternMelt(DF::DataFrame, temperature::Tuple = (30, 150))
  gradient = calcGradient(DF, temperature)
  DF[:,2] = DF[:, 2] - (DF[:, 5] * gradient)
  DF[:,2] = DF[:,2] .- DF[10,2]
  return DF
end

"""
Wraps the flaternMelt method to accept a file path string instead of a dataframe.
"""
function flaternMelt(seriesPath::String)
  return CSV.File(seriesPath) |> DataFrame |> flaternMelt
end

"""
Converts the y axis to Joules from Watts by dividing through by the rate of
heating (run speed). 
"""
function runSpeedAdjust(DF::DataFrame, temperature::Tuple = (30, 150))
  DF[:,2] = DF[:,2]./runSpeed(DF, temperature)
  return DF
end

"""
Calculate the speed in degrees per second for the run in the temperature range
given (uses the melting portion of the curve) 
"""
function runSpeed(DF::DataFrame, temperature::Tuple)
  temp1 = findfirst(x -> x>temperature[1], DF[:,5])
  temp2 = findfirst(x -> x>temperature[2], DF[:,5])
  return speed = (temperature[2] - temperature[1])/(DF[temp2, 1] - DF[temp1, 1])
end

"""
Converts the units of the mass from milligrams (used in the machine software) to grams.
"""
function runMassAdjust(DF::DataFrame, mass)
  DF[:,2] = DF[:,2]./(mass/1000)
  return DF
end

"""
Converts the units from minutes (the output of the machine) to seconds.
"""
function correctUnits_Speed(DF::DataFrame)
  DF[:,1] = DF[:,1] .* 60
  return DF
end

"""
Converts the units from mw (the output of the machine) to w.
"""
function correctUnits_Heatflow(DF::DataFrame)
  DF[:,2] = DF[:,2] ./ 1000
  DF[:,3] = DF[:,3] ./ 1000
  return DF
end

"""
Wraps the calcSpecificHeat method to accept a file path string instead of a
ready made dataframe.
"""
function calcSpecificHeat(seriesPath::String; kwargs...)
  return CSV.File(seriesPath) |>
  x -> DataFrame(x) |>
  x -> calcSpecificHeat(x; kwargs...)
end

"""
Takes the raw dataframe and returns the dataframe with an added column containing the specific heat capacity.
"""
function calcSpecificHeat(DF::DataFrame)
  return DF |>
  x -> x
end
