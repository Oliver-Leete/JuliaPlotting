function preMeltGradiant(DF::DataFrame, temperature::Tuple = (60, 120))
  temp1 = findfirst(x -> x>temperature[1], DF[:,5])
  temp2 = findfirst(x -> x>temperature[2], DF[:,5])
  return gradiant = (DF[temp2, 2] - DF[temp1, 1])/(temperature[2] - temperature[1])
end

function flaternMelt(DF::DataFrame, temperature::Tuple = (30, 150))
  gradiant = preMeltGradiant(DF, temperature)
	meltCurve = FilterHeating(DF, temperature[1])
	meltCurve[:,2] = meltCurve[:, 2] - (meltCurve[:, 5] * gradiant)
	return meltCurve
end

function flaternMelt(seriesPath::String)
  DF = CSV.File(seriesPath) |> DataFrame
  return flaternMelt(DF)
end
