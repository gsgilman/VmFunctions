#code modified from http://stackoverflow.com/questions/19812868/getting-all-virtualmachines-using-api-rbvmomi

module VmFunctions
  class List
    attr_accessor :machines, :folders, :templates
    def get_vms(dc) # recursively go through a datacenter, dumping vm info
      @machines = []
      @folders = []
      @templates = []
      dc.vmFolder.childEntity.each do |x|
        name, junk = x.to_s.split('(')
        case name
          when 'Folder'
            @folders << x
          when 'VirtualMachine'
            if x.config.template
              @templates << x
            else
              @machines << x
            end
          else
            puts '# Unrecognized Entity ' + x.to_s
        end
      end
    end
  end
end
