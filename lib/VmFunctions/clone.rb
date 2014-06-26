require 'waitutil'
module VmFunctions
  class Clone
    attr_accessor :vim, :dc

    def initialize
      @vim = vim
      @dc = dc
      @host = vim.host
    end

    def find_pool(poolName)
      baseEntity = dc.hostFolder
      entityArray = poolName.split('/')
      entityArray.each do |entityArrItem|
        if entityArrItem != ''
          if baseEntity.is_a? RbVmomi::VIM::Folder
            baseEntity = baseEntity.childEntity.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ClusterComputeResource
            baseEntity = baseEntity.resourcePool.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ResourcePool
            baseEntity = baseEntity.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          else
            abort "Unexpected Object type encountered #{baseEntity.type} while finding resourcePool"
          end
        end
      end

      baseEntity = baseEntity.resourcePool if not baseEntity.is_a?(RbVmomi::VIM::ResourcePool) and baseEntity.respond_to?(:resourcePool)
      baseEntity
    end

    def clone_vm (vm_source, vm_name, vm_mac)
      vm = dc.find_vm(vm_source)
      relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec(:pool => find_pool(host))
      spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocateSpec, :powerOn => false, :template => false)
      task = vm.CloneVM_Task(:folder => vm.parent, :name => vm_name, :spec => spec)
      print "Cloning ..."
      task.wait_for_completion

      if vm_mac
        clone = vim.serviceInstance.find_datacenter.find_vm(vm_name)
        card = clone.config.hardware.device.grep(RbVmomi::VIM::VirtualEthernetCard).find { |x| x.deviceInfo.label == "Network adapter 1" } or
        abort "Can't find source network card to customize"
        card.macAddress = vm_mac
        card_spec = {
          :deviceChange => [
            {
                :operation => :edit,
                :device => card
            }
          ]
        }
        clone.ReconfigVM_Task(:spec => card_spec).wait_for_completion
        puts "Finished Changing the MAC to #{@vm_mac}"
      end
    #puts clone.macs
    #puts clone.guest.ipAddress
    end
  end
end
