require 'VmFunctions/power'
require 'VmFunctions/list'
require 'VmFunctions/clone'
require 'VmFunctions/tools'
require 'rbvmomi'
module VmFunctions
  class Connection
    attr_accessor :vim, :dc

    def connect(host, user, pass)
      @vim = RbVmomi::VIM.connect host: host, user: user, password: pass, insecure: true
      @host = host
    end

    def get_dc(dc_name)
      @dc = @vim.serviceInstance.find_datacenter(dc_name) or fail 'datacenter not found'
    end
  end
end

con = VmFunctions::Connection.new
con.connect('10.0.1.95','Administrator@vsphere.local','Clock2@10')
con.get_dc('Data')
list.get_vms(con.dc)
