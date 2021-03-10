module JuliaPlotting

  using CSV
  using DataFrames
  using Plots
  using Dates
  using PGFPlotsX
	using NumericalIntegration
	using Pipe: @pipe

  export PlotDSCProfile!, PlotDSC!, PlotDSCTime!
  export PlotDSCHeatingTemp!, PlotDSCHeatingTime!
  export PlotDSCCoolingTemp!, PlotDSCCoolingTime!
  export PlotTensileStressStrain!, PlotStressBar!
	export preMeltGradiant, flaternMelt, flaternMeltAdjust

  export Thermocouple_Plot
  export Tensile_StressStrain

  include("TimeConversions.jl")
  include("DSCFilters.jl")
  include("DSCPlottingBasic.jl")
  include("DSCPlottingMelting.jl")
  include("DSCPlottingCooling.jl")
	include("DSCSpecificHeat.jl")
  include("DSCMeltPercentage.jl")
  include("DSCPlottingDuel.jl")
  include("TensilePlotting.jl")
  include("ThermocouplePlotting.jl")

  plotSize = (720,400)
end
