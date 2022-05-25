"""
  FilterHeating(df::DataFrame, temperature)

Filters the dataframe between two temperatures given by the temperature variable. If a  tuple is given then the first value is taken as the starting value of the range and the second the end of the range. If a single value is given then it is taken as the start of the range and the maximum temperature is taken as the end of the range.

Unlike FilterCooling(), this uses the first instance of the values, so it is useful for the heating range of the DSC curve.
"""
function FilterHeating(df::DataFrame, temperature::Number)
  first = findfirst(x -> x>temperature, df[!, "sampleTemp"])
  last = findmax(df[!, "sampleTemp"])[2]
  df = df[first:last,:]
  return df
end

function FilterHeating(df::DataFrame, temperature::Tuple)
  first = findfirst(x -> x>temperature[1], df[!, "sampleTemp"])
  last = findfirst(x -> x>temperature[2], df[!, "sampleTemp"])
  df = df[first:last,:]
  return df
end

"""
  FilterCooling(df::DataFrame, temperature)

Filters the dataframe between two temperatures given by the temperature variable. If a  tuple is given then the first value is taken as the starting value of the range and the second the end of the range. If a single value is given then it is taken as the end of the range and the maximum temperature is taken as the start of the range.

Unlike FilterHeating(), this uses the last instance of the values, so it is useful for the cooling range of the DSC curve.
"""
function FilterCooling(df::DataFrame, temperature::Number)
  first = findmax(df[!, "sampleTemp"])[2]
  last = findlast(x -> x>temperature, df[!, "sampleTemp"])
  df = df[first:last,:]
  return df
end

function FilterCooling(df::DataFrame, temperature::Tuple)
  first = findlast(x -> x>temperature[2], df[!, "sampleTemp"])
  last = findlast(x -> x>temperature[1], df[!, "sampleTemp"])
  df = df[first:last,:]
  return df
end
