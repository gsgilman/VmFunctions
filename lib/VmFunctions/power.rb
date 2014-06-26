
module VmFunctions
  class Power
    attr_accessor :vim, :dc

    def initialize(vim, dc)
      @vim = vim
      @dc = dc
    end

    def power_on(machines)
      machines.each do |x|
        vm = dc.find_vm(x)
        if vm.runtime.powerState == "poweredOff"
          vm.PowerOnVM_Task.wait_for_completion
          puts "#{vm.name} was powered on"
        else
          puts "#{vm.name} is already powered on"
        end
      end
    end

   def power_off(machines)
      machines.each do |x|
        vm = dc.find_vm(x)
        if vm.runtime.powerState == "poweredOn"
          vm.ShutdownGuest
          WaitUtil.wait_for_condition("vm is powered off", :timeout_sec => 60, :delay_sec => 0.5) do
            vm.runtime.powerState == "poweredOff"
          end
          puts "#{vm.name} was powered off"
        else
          puts "#{vm.name} is already powered off"
        end
      end
    end

    def restart_guest(machines)
      power_off(machines)
      power_on(machines)
    end

  end
end
