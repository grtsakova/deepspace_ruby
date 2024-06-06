# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'PowerEfficientSpaceStation.rb'
require_relative 'BetaPowerEfficientSpaceStationToUI.rb'

module Deepspace
  
  class BetaPowerEfficientSpaceStation < PowerEfficientSpaceStation
    
    @@EXTRAEFFICIENCY = 1.2
    
    def initialize(station)
      super(station)
    end
    
    def getUIversion
      BetaPowerEfficientSpaceStationToUI.new(self)
    end
    
    def fire
      return super * @@EXTRAEFFICIENCY
    end
    
  end  
end
