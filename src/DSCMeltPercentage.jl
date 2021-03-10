function flaternMeltAdjust(seriesPath::String, mass, temp::Tuple=(30,150))
  return @pipe CSV.File(seriesPath) |>
	DataFrame(_) |>
  flaternMeltAdjust(_, mass, temp)
end

function flaternMeltAdjust(DF::DataFrame, mass, temp::Tuple=(30,150))
  return @pipe DF |>
  fixYoSpeed(_) |>
  fixYoHeatflow(_) |>
  FilterHeating(_, temp[1]) |>
  flaternMelt(_, temp) |>
  runSpeedAdjust(_, temp) |>
  runMassAdjust(_, mass) |>
	tempTntegrate(_, (160, 200))
end

function tempTntegrate(DF::DataFrame, intTemp::Tuple)
  temp1 = findfirst(x -> x>intTemp[1], DF[:,5])
  temp2 = findfirst(x -> x>intTemp[2], DF[:,5])
  return area = cumul_integrate(DF[temp1:temp2, 5], DF[temp1:temp2, 2])
end

function preMeltGradiant(DF::DataFrame, temperature::Tuple = (60, 120))
  temp1 = findfirst(x -> x>temperature[1], DF[:,5])
  temp2 = findfirst(x -> x>temperature[2], DF[:,5])
  return gradiant = (DF[temp2, 2] - DF[temp1, 2])/(temperature[2] - temperature[1])
end

function flaternMelt(DF::DataFrame, temperature::Tuple = (30, 150))
  gradiant = preMeltGradiant(DF, temperature)
  DF[:,2] = DF[:, 2] - (DF[:, 5] * gradiant)
  DF[:,2] = DF[:,2] .- DF[10,2]
  return DF
end

function flaternMelt(seriesPath::String)
  return CSV.File(seriesPath) |> DataFrame |> flaternMelt
end

function runSpeedAdjust(DF::DataFrame, temperature::Tuple = (30, 150))
  DF[:,2] = DF[:,2]./preMeltSpeed(DF, temperature)
  return DF
end

function preMeltSpeed(DF::DataFrame, temperature::Tuple)
  temp1 = findfirst(x -> x>temperature[1], DF[:,5])
  temp2 = findfirst(x -> x>temperature[2], DF[:,5])
  return speed = (temperature[2] - temperature[1])/(DF[temp2, 1] - DF[temp1, 1])
end

function runMassAdjust(DF::DataFrame, mass)
  DF[:,2] = DF[:,2]./(mass/1000)
  return DF
end

function fixYoSpeed(DF::DataFrame)
  DF[:,1] = DF[:,1] .* 60
  return DF
end

function fixYoHeatflow(DF::DataFrame)
  DF[:,2] = DF[:,2] ./ 1000000
  DF[:,3] = DF[:,3] ./ 1000000
  return DF
end
