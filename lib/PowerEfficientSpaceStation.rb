# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'SpaceStation.rb'
require_relative 'PowerEfficientSpaceStationToUI.rb'
require_relative 'Transformation.rb'


module Deepspace
  
  class PowerEfficientSpaceStation < SpaceStation
    
    @@EFFICIENCYFACTOR = 1.10
    
    def initialize(station)
      copy(station)
    end
    
    def getUIversion
      PowerEfficientSpaceStationToUI.new(self)
    end
    
    def fire
      return super * @@EFFICIENCYFACTOR
    end
    
    def protection
      return super * @@EFFICIENCYFACTOR
    end
    
    def setLoot(loot)
      super(loot)
      if(loot.efficient)
        return Transformation::GETEFFICIENT
      else
        return Transformation::NOTRANSFORM
      end
    end
    
  end
  
end