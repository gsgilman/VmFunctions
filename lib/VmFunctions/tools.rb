
module VmFunctions
  class Tools
    attr_accessor(:vim, :dc)

    def initialize(vim, dc)
      @vim = vim
      @dc = dc
    end

    def upgrade_tools(machines)
      machines.each do |x|
        if x.guest.toolsVersionStatus == "guestToolsNeedUpgrade"
          if x.runtime.powerState == "poweredOff"
            x.PowerOnVM_Task.wait_for_completion
            puts x.name + " was powered on"
            x.UpgradeTools_Task.wait_for_progress
            puts "the tools for " + x.name + " were upgraded"
            x.PowerOffVM_Task.wait_for_completion
            puts x.name + " was powered off"
          else
            x.UpgradeTools_Task.wait_for_completion
            puts "the tools for " + x.name + " were upgraded"
          end
        else
          next
        end
      end
    end

  end
end
