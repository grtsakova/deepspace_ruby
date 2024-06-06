# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'SuppliesPackage.rb'
require_relative 'Hangar.rb'
require_relative 'Damage.rb'
require_relative 'Weapon.rb'
require_relative 'ShieldBooster.rb'
require_relative 'Loot.rb'
require_relative 'SpaceStationToUI.rb'
require_relative 'CardDealer.rb'
require_relative 'Transformation.rb'

module Deepspace
  class SpaceStation
    
    @@MAXFUEL = 100
    @@SHIELDLOSSPERUNITSHOT = 0.1
    
    attr_reader :ammoPower, :fuelUnits, :hangar, :name, :nMedals, :pendingDamage,
      :shieldBoosters, :shieldPower, :weapons
    
    def initialize(n,supplies)
      @name = n
      @ammoPower = supplies.ammoPower
      @fuelUnits = supplies.fuelUnits
      @shieldPower = supplies.shieldPower
      @hangar = nil
      @shieldBoosters = []
      @weapons = []
      @pendingDamage = nil
      @nMedals = 0
    end
    
    def copy(station)
      @name = station.name
      @ammoPower = station.ammoPower
      @fuelUnits = station.fuelUnits
      @shieldPower = station.shieldPower
      @hangar = station.hangar
      @shieldBoosters = station.shieldBoosters
      @weapons = station.weapons
      @pendingDamage = station.pendingDamage
      @nMedals = station.nMedals
    end
    
    def assignFuelValue(f)
      if(f > @@MAXFUEL)
        @fuelUnits = @@MAXFUEL
      end
    end
    
    def cleanPendingDamage
      if(@pendingDamage.hasNoEffect) then
        @pendingDamage = nil
      end  
    end
    
    def cleanUpMountedItems
 
      size = @weapons.size
      for i in (size-1).downto(0) do
        if @weapons.at(i).uses == 0 then
          @weapons.delete_at(i)
        end
      end
      
      size = @shieldBoosters.size
      for i in (size-1).downto(0) do
        if @shieldBoosters.at(i).uses == 0 then
          @shieldBoosters.delete_at(i)
        end
      end
    end
    
    def discardHangar
      @hangar = nil
    end
    
    def discardShieldBooster(i)
      size = @shieldBoosters.size
      if (i >= 0 && i < size) then
        s = @shieldBoosters.delete_at(i)
        if (@pendingDamage != nil)
          @pendingDamage.discardShieldBooster
          cleanPendingDamage
        end
      end
    end
    
    def discardShieldBoosterInHangar(i)
      if(@hangar != nil) then
        @hangar.removeShieldBooster(i)
      end
    end
    
    def discardWeapon(i)
      size = @weapons.size
      if(i >= 0 && i < size)
        w = @weapons.delete_at(i)
        if(@pendingDamage != nil)
          @pendingDamage.discardWeapon(w) #maha weapon ot pending damage
          cleanPendingDamage
        end
      end 
    end
    
    def discardWeaponInHangar(i)
      if(@hangar != nil) then
        @hangar.removeWeapon(i)
      end
    end
    
    def fire
      size = @weapons.size
      factor = 1.0
      for i in 0...size do
        w = @weapons.at(i)
        factor *= w.useIt
      end
      return @ammoPower*factor    
    end 
    
   
    def getUIversion
      SpaceStationToUI.new(self)
    end
    
    def mountShieldBooster(i)
      if(@hangar != nil) then
        escudo = @hangar.removeShieldBooster(i)
        if (escudo != nil) then
          @shieldBoosters.push(escudo)
        end
      end
    end
    
    def mountWeapon(i)
      if(@hangar != nil) then
        arma = @hangar.removeWeapon(i)
        if (arma != nil) then
          @weapons.push(arma)
        end
      end
      
    end
    
    def getSpeed
      return @fuelUnits / @@MAXFUEL
    end
    
    def move
      @fuelUnits -= @fuelUnits * getSpeed
      if(@fuelUnits < 0)
        @fuelUnits = 0
      end
    end
    
    def protection
      size = @shieldBoosters.size
      factor = 1.0
      for i in 0...size do
        s = @shieldBoosters.at(i)
        factor *= s.useIt
      end
      return @shieldPower*factor
    end
    
    def receiveHangar(h)
      if (@hangar == nil) then
        @hangar = h
      end
      
    end
    
    def receiveShieldBooster(s)
      if (@hangar != nil) then
        return @hangar.addShieldBooster(s);
      else
        return false
      end
    end
    
    def receiveShot(shot)
      myProtection = protection
      if (myProtection >= shot) then
        @shieldPower -= @@SHIELDLOSSPERUNITSHOT*shot
        @shieldPower = [0.0,@shieldPower].max #ne moje da bude oricatelno
        return ShotResult::RESIST
      else
        @shieldPower = 0.0
        return ShotResult::DONOTRESIST
      end
    end
    
    def receiveSupplies(s)
      @ammoPower += s.ammoPower
      @shieldPower += s.shieldPower
      @fuelUnits += s.fuelUnits
      assignFuelValue(@fuelUnits)
    end
    
    def receiveWeapon(w)
      if (@hangar != nil) then
        return @hangar.addWeapon(w);
      else
        return false
      end
      
    end
    
    def setLoot(loot)
      dealer = CardDealer.instance
      h = loot.nHangars
      if (h > 0)
        hangar = dealer.nextHangar
        receiveHangar(hangar)
      end
      
      elements = loot.nSupplies
      
      for i in 0...elements do
        sup = dealer.nextSuppliesPackage
        receiveSupplies(sup)
      end
      
      elements = loot.nWeapons
      
      for i in 0...elements do
        weap = dealer.nextWeapon
        receiveWeapon(weap)
      end
      
      elements = loot.nShields
      
      for i in 0...elements do
        sh = dealer.nextShieldBooster
        receiveShieldBooster(sh)
      end
      
      medals = loot.nMedals
      @nMedals += medals
      
      if loot.efficient then
        return Transformation::GETEFFICIENT
      elsif loot.spaceCity then
        return Transformation::SPACECITY
      else
        return Transformation::NOTRANSFORM
      end
    end
    
    def setPendingDamage(d)
      @pendingDamage = d.adjust(@weapons, @shieldBoosters)
      cleanPendingDamage
    end
    
    def validState
      return (@pendingDamage == nil || @pendingDamage.hasNoEffect)
    end
    
    def to_s
      out="Space Station - Name: #{name}\n"
      out+="\tnMedals: #{@nMedals}, Fuel units: #{@fuelUnits.round(2)}, Power: #{@ammoPower}, Shields: #{@shieldPower}\n"
      out+="\tWeapons: [#{@weapons.join(', ')}]\n"
      out+="\tShieldBooster: [#{@shieldBoosters.join(', ')}]\n"
      out+="\tHangars: #{@hangar}\n"
      out+="\tPendingDamage: #{@pendingDamage}\n" 
      out+="------- end of Space Station >> #{@name} << -------"
    return out
    end
    
  end
end
