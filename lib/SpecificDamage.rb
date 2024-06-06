# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'Damage.rb'
require_relative 'SpecificDamageToUI.rb'
require_relative 'WeaponType.rb'

module Deepspace
  
  class SpecificDamage < Damage
    
    attr_reader :weapons
    
    def initialize(wl,s)
      super(s)
      if(wl != nil)
        @weapons = Array.new(wl)
      else
        @weapons = nil
      end
    end
    
    public_class_method :new
    
    def copy
      SpecificDamage.new(@weapons, @nShields)
    end
    
    def getUIversion
      SpecificDamageToUI.new(self)
    end
  
    def arrayContainsType(w,t)
      if(w.include?(t))
        w.index(t)
      else 
        return -1;
      end
    end
    
    def adjust(w,s) #lo que tiene la estacion
      weaponTypes = []

      for i in 0...w.length do
        weaponTypes.push(w.at(i).type)
      end
   
      adjusted = weaponTypes & @weapons # [1,2,3,3] & [3,3,4,5] = [3]
      for i in 0...adjusted.length
        min = [weaponTypes.count(adjusted[i]), @weapons.count(adjusted[i])].min
        for j in 2..min do #si se repiten mas de una vez, para incluir la segunda 3
          adjusted.push(adjusted[i]) #[3,3]
        end
      end
      
      return SpecificDamage.new(adjusted, [@nShields, s.length].min)
    end
    
    def discardWeapon(w)
      i = @weapons.index(w.type)
      if (i != nil)
        @weapons.delete_at(i)
      end
    end
    
    def hasNoEffect
      return @weapons.empty? && super
    end
    
    def to_s
      return super + " weapons: " + @weapons.join(", ")
    end
    
  end
end
