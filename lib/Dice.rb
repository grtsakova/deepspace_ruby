34# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'GameCharacter.rb'

module Deepspace
  class Dice
    def initialize ()
      @NHANGARSPROB = 0.25
      @NSHIELDSPROB = 0.25
      @NWEAPONSPROB = 0.33
      @FIRSTSHOTPROB = 0.5
      @generator = Random.new
      @EXTRAEFFICIENCYPROB = 0.8
    end
    
    def initWithNHangars
      number = @generator.rand()
      if number <= @NHANGARSPROB
        return 0
      else
        return 1
      end
    end
    
    
    def initWithNWeapons
      number = @generator.rand()
      if number <= @NWEAPONSPROB
        return 1
      elsif number > 2*@NWEAPONSPROB
        return 3
      else
        return 2
      end
    end
    
    def initWithNShields()
      number = @generator.rand()
      if number <= @NSHIELDSPROB
        return 0
      else
        return 1
      end
    end
    
    def whoStarts(nPlayers)
      number = @generator.rand(nPlayers)
      return number
    end
    
    def firstShot
      number = @generator.rand()
      if number <= @FIRSTSHOTPROB
        return GameCharacter::SPACESTATION
      else
        return GameCharacter::ENEMYSTARSHIP
      end
    end
    
    def spaceStationMoves(speed)
      number = @generator.rand()
#      if number <= speed
#        return true
#      else
#        return false
#      end
      return number <= speed
    end
    
    def extraEfficiency
      number = @generator.rand()
      return number < @EXTRAEFFICIENCYPROB 
    end
      
    def to_s
      "NHANGARSPROB: #{@NHANGARSPROB} NSHIELDSPROB: #{@NSHIELDSPROB} NWEAPONSPROB: #{@NWEAPONSPROB} FIRSTSHOTPROB: #{@FIRSTSHOTPROB}"
    end
    

  end
end
