using CSV
using DataFrames

"""
  FilterHeating(DF::DataFrame, temperature)

Filters the dataframe between two temperatures given by the temperature variable. If a  tuple is given then the first value is taken as the starting value of the range and the second the end of the range. If a single value is given then it is taken as the start of the range and the maximum temperature is taken as the end of the range.

Unlike FilterCooling(), this uses the first instance of the values, so it is useful for the heating range of the DSC curve.
"""
function FilterHeating(DF::DataFrame, temperature::Number)
  first = findfirst(x -> x>temperature, DF[:,5])
  last = findmax(DF[:,5])[2]
  DF = DF[first:last,:]
  return DF
end

function FilterHeating(DF::DataFrame, temperature::Tuple)
  first = findfirst(x -> x>temperature[1], DF[:,5])
  last = findfirst(x -> x>temperature[2], DF[:,5])
  DF = DF[first:last,:]
  return DF
end

"""
  FilterCooling(DF::DataFrame, temperature)

Filters the dataframe between two temperatures given by the temperature variable. If a  tuple is given then the first value is taken as the starting value of the range and the second the end of the range. If a single value is given then it is taken as the start of the range and the maximum temperature is taken as the end of the range.

Unlike FilterHeating(), this uses the lastirst instance of the values, so it is useful for the cooling range of the DSC curve.
"""
function FilterCooling(DF::DataFrame, temperature::Number)
  first = findmax(DF[:,5])[2]
  last = findlast(x -> x>temperature, DF[:,5])
  DF = DF[first:last,:]
  return DF
end

function FilterCooling(DF::DataFrame, temperature::Tuple)
  first = findlast(x -> x>temperature[2], DF[:,5])
  last = findlast(x -> x>temperature[1], DF[:,5])
  DF = DF[first:last,:]
  return DF
end
