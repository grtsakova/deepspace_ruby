# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'DamageToUI.rb'

module Deepspace
  class Damage

    attr_reader :nShields

    def initialize(s)
      @nShields = s
    end
    
    private_class_method :new
    
    def copy
      #Abstracto
    end

    def getUIversion
#      DamageToUI.new(self)
    end

    def adjust(w,s)
       #Abtracto
    end
    
    def discardWeapon(w)
      #Abstracto
    end

    def discardShieldBooster
      if(@nShields > 0) then
        @nShields -= 1
      end
    end

    def hasNoEffect
      @nShields == 0
    end

    def to_s
      return "nShields: #{@nShields}"
    end


  end

end
