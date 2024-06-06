# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'WeaponToUI.rb'
require_relative 'WeaponType.rb'

module Deepspace
  class Weapon
    attr_reader :name, :type, :uses
    
    def initialize(name,type,uses)
      @name = name
      @type = type
      @uses = uses
    end
    
    def self.newCopy(s)
      new(s.name, s.type, s.uses)
    end
    
    def getUIversion
      WeaponToUI.new(self)
    end
    
    def power
      return @type.power
    end
    
    def useIt
      if @uses > 0
        @uses -= 1
        return power
      else
        return 1.0
      end
    end
    
    def to_s
      "name: #{@name} type: #{@type} uses: #{@uses}"
    end
    
    
  
  end
end
