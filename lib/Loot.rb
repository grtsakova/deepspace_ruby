# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'LootToUI.rb'

module Deepspace
  class Loot
    
    attr_reader :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals,
      :efficient, :spaceCity  
    
    def initialize(nsu,nw,nsh,nh,nm,ef=false,city=false)
      @nSupplies = nsu
      @nWeapons = nw
      @nShields = nsh
      @nHangars = nh
      @nMedals = nm
      @efficient = ef
      @spaceCity = city
      if( ef && city) then
        @efficient = false
      end
    end
    
    def to_s
      return "nSupplies: #{@nSupplies} nWeapons: #{@nWeapons} nShields: #{@nShields} nHangars: #{@nHangars} nMedals: #{@nMedals}
      getEfficient: #{@efficient}, spaceCoty #{@spaceCity}"
    end
    
    def getUIversion
      LootToUI.new(self)
    end
    
  end
end

