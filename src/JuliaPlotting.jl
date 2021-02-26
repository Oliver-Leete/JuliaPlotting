module JuliaPlotting

  import CSV
  import DataFrames
  import Plots
  import Dates
  import PGFPlotsX

  export PlotDSCProfile!, PlotDSC!, PlotDSCTime!
  export PlotDSCHeatingTemp!, PlotDSCHeatingTime!
  export PlotDSCCoolingTemp!, PlotDSCCoolingTime!
  export PlotTensileStressStrain!, PlotStressBar!
	export preMeltGradiant, flaternMelt

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
