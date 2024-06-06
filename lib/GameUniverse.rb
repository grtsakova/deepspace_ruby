# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'GameUniverseToUI.rb'
require_relative 'SpaceStation.rb'
require_relative 'GameStateController.rb'
require_relative 'Dice.rb'
require_relative 'EnemyStarShip.rb'
require_relative 'CardDealer.rb'
require_relative 'GameState.rb'
require_relative 'CombatResult.rb'
require_relative 'ShotResult.rb'
require_relative 'Transformation.rb'
require_relative 'PowerEfficientSpaceStation.rb'
require_relative 'BetaPowerEfficientSpaceStation.rb'
require_relative 'SpaceCity.rb'

module Deepspace
  class GameUniverse
    
    @@WIN = 10
    
    def initialize
      @currentStationIndex = 0
      @turns = 0
      @gameState = GameStateController.new
      @spaceStations = []
      @currentStation = nil
      @dice = Dice.new
      @currentEnemy = nil
      @haveSpaceCity = false
    end
    
    def state
     return @gameState.state
    end
    
    def combatGo(station, enemy)
      ch = @dice.firstShot #station or enemy
      if (ch == GameCharacter::ENEMYSTARSHIP) then
        fire = enemy.fire
        result = station.receiveShot(fire)
        if (result == ShotResult::RESIST) then
          fire = station.fire
          result = enemy.receiveShot(fire)
          enemyWins = (result == ShotResult::RESIST) #ako resistne => true, enemito pecheli ako resistne
        else
          enemyWins = true #enemito pecheli, ako station ne e resistnal
        end
      else #strelq purvo station
        fire = station.fire
        result = enemy.receiveShot(fire)
        enemyWins = (result == ShotResult::RESIST)
      end
      
      if (enemyWins)
        s = station.getSpeed
        moves = @dice.spaceStationMoves(s)
        if (!moves) #ako ne se premesti, poluchava damage
          damage = enemy.damage #damage e atribut
          station.setPendingDamage(damage)
          combatResult = CombatResult::ENEMYWINS
        else
          station.move
          combatResult = CombatResult::STATIONESCAPES
        end
      else # station wins
        aLoot = enemy.loot
        transform = station.setLoot(aLoot)
        if (transform == Transformation::GETEFFICIENT) then
          makeStationEfficient
          combatResult = CombatResult::STATIONWINSANDCONVERTS
        elsif (transform == Transformation::SPACECITY) then
          createSpaceCity
          combatResult = CombatResult::STATIONWINSANDCONVERTS
        else
          combatResult = CombatResult::STATIONWINS
        end
      end
      @gameState.next(@turns, @spaceStations.size)
      return combatResult
    end
    
    def combat
      state = @gameState.state
      if ((state == GameState::BEFORECOMBAT) || (state == GameState::INIT)) then
        return combatGo(@currentStation,@currentEnemy)
      else
        return CombatResult::NOCOMBAT
      end
    end
    
    def discardHangar
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.discardHangar
      end
    end
    
    def discardShieldBooster(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.discardShieldBooster(i)
      end
    end
    
    def discardShieldBoosterInHangar(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.discardShieldBoosterInHangar(i)
      end
    end
    
    def discardWeapon(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.discardWeapon(i)
      end
    end
    
    def discardWeaponInHangar(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.discardWeaponInHangar(i)
      end
    end 
    
    def getUIversion
      GameUniverseToUI.new(@currentStation,@currentEnemy)
    end
    
    def haveAWinner
      return @currentStation.nMedals == @@WIN
      
    end
    
    def init(names)
      state = @gameState.state
      if (state == GameState::CANNOTPLAY)
        @spaceStations = Array.new
        dealer = CardDealer.instance
        for i in 0...names.size do
          supplies = dealer.nextSuppliesPackage
          station = SpaceStation.new(names.at(i), supplies)
          @spaceStations.push(station)
          nh = @dice.initWithNHangars
          nw = @dice.initWithNWeapons
          ns = @dice.initWithNShields
          lo = Loot.new(0, nw, ns, nh, 0)
          station.setLoot(lo)
        end
        
        @currentStationIndex = @dice.whoStarts(names.size) #whoStarts(nPlayers)
        @currentStation = @spaceStations.at(@currentStationIndex)
        @currentEnemy = dealer.nextEnemy
        @gameState.next(@turns, @spaceStations.size)
      end
      
    end
    
    def mountShieldBooster(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.mountShieldBooster(i)
      end
    end
    
    def mountWeapon(i)
      if (@gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT) then
        @currentStation.mountWeapon(i)
      end
    end
    
    def nextTurn
      state = @gameState.state
      if (state == GameState::AFTERCOMBAT)
        stationState = @currentStation.validState
        if (stationState)
          @currentStationIndex = (@currentStationIndex + 1) % @spaceStations.size #to restart after the last one
          @turns += 1
          @currentStation = @spaceStations.at(@currentStationIndex)
          @currentStation.cleanUpMountedItems #uses=0
          dealer = CardDealer.instance
          @currentEnemy = dealer.nextEnemy
          @gameState.next(@turns, @spaceStations.size)
          return true
        end
        return false
      end
      return false
    end
    
    def makeStationEfficient
      if (@dice.extraEfficiency) then
        @currentStation = BetaPowerEfficientSpaceStation.new(@currentStation)
      else
        @currentStation = PowerEfficientSpaceStation.new(@currentStation)
      end
    end
    
    def createSpaceCity
      if (@haveSpaceCity == false) then
        collaborators = Array.new
        for i in 0...@spaceStations.size do
          collaborators << @spaceStations.at(i)
        end
        collaborators.delete(@currentStation)
        @currentStation = SpaceCity.new(@currentStation,collaborators)
        @haveSpaceCity = true
      end
    end
    
    def to_s
      return "WIN: #{@WIN}, CurrentStationIndex: #{@currentStationIndex}, Turns: #{@turns},
      Dice: #{@dice}, SpaceStations: #{@spaceStations}, CurrentStation: #{@currentStation},
      GameState: #{@gameState}, CurrentEnemy: #{@currentEnemy}"
    end
    

  end
end
