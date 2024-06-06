# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'NumericDamageToUI.rb'
require_relative 'Damage.rb'

module Deepspace
  class NumericDamage < Damage
    
    attr_reader :nWeapons
    
    def initialize(w,s)
      super(s)
      @nWeapons = w
    end
    
    public_class_method :new
    
    def copy
      NumericDamage.new(@nWeapons, @nShields)
    end
    
    def getUIversion
      NumericDamageToUI.new(self)
    end
    
    def adjust(w,s)
      return NumericDamage.new([@nWeapons, w.length].min, [@nShields, s.length].min)
    end
    
    def discardWeapon(w)
      if (@nWeapons > 0)
          @nWeapons -= 1
      end
    end
    
    def hasNoEffect
      return @nWeapons == 0 && super
    end
    
    def to_s
      return super + " nWeapons: #{@nWeapons}"
    end
  end
end
