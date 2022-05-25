module JuliaPlotting

  using CSV
  using DataFrames
  using Plots
  using Dates
  using PGFPlotsX
  using NumericalIntegration

  export PlotDSCProfile!, PlotDSC!, PlotDSCTime!
  # export PlotDSCHeatingTemp!, PlotDSCHeatingTime!
  # export PlotDSCCoolingTemp!, PlotDSCCoolingTime!
  export PlotTensileStressStrain!, PlotStressBar!
  # export preMeltGradiant, flaternMeltAdjust

  export integrateHeatflow
  export DPMratio
  export flaternMelt
  export flaternCool
  export pathToDF
  export keepNth
  export plotSize
  export correctUnits_Speed
  export correctUnits_Heatflow
  export runMassAdjust
  export FilterHeating
  export FilterCooling
  export zeroMelt
  export zeroCool
  export runSpeedAdjust

  export profilePlotter
  export regPlotter
  export meltPlotter
  export meltTimePlotter
  export coolPlotter
  export unsubPlotter
  export spheatPlotter
  export heatOfMeltPlotter
  export energyPlotter
  export meltStatePlotter

  export Thermocouple_Plot
  # export Tensile_StressStrain

  include("TimeConversions.jl")
  include("DSCFilters.jl")
  include("DSCPlottingFunctions.jl")
  include("DSCPlottingBasic.jl")
  # include("DSCPlottingMelting.jl")
  # include("DSCPlottingCooling.jl")
  include("DSCMeltPercentage.jl")
  # include("DSCSpecificHeat.jl")
  # include("DSCPlottingDuel.jl")
  include("TensilePlotting.jl")
  include("ThermocouplePlotting.jl")

  plotSize = (720,400)
end
