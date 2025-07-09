module JuliaPlotting

  using CSV
  using DataFrames
  using Plots
  using Dates
  # using PGFPlotsX
  using NumericalIntegration
  using LaTeXStrings

  # export PlotDSCHeatingTemp!, PlotDSCHeatingTime!
  # export PlotDSCCoolingTemp!, PlotDSCCoolingTime!
  export PlotTensileStressStrain!, PlotStressBar!
  # export preMeltGradiant, flaternMeltAdjust

  export integrateCoolflow
  export integrateHeatflow
  export DPMratio
  export DPMratioCool
  export flaternMelt
  export flaternCool
  export pathToDF
  export keepNth
  export plotSize
  export square
  export correctUnits_Speed
  export correctUnits_Heatflow
  export runMassAdjust
  export FilterHeating
  export FilterCooling
  export FilterAll
  export zeroMelt
  export zeroCool
  export runSpeedAdjust
  export calcSPH
  export calcSPHCool
  export subFlatMelt

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
  export unsubCoolPlotter
  export spheatCoolPlotter
  export heatOfMeltCoolPlotter
  export energyCoolPlotter
  export meltStateCoolPlotter

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

  plotSize = (600,300)
  square = (300, 300)
end
