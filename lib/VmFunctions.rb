require 'rbvmomi'
require 'waitutil'
require './VmFunctions/power'
require './VmFunctions/list'
require './VmFunctions/clone'
require './VmFunctions/tools'
module VmFunctions
  class Connection
    attr_accessor :vim, :dc

    def connect(host, user, pass)
      @vim = RbVmomi::VIM.connect host: '10.0.1.16', user: 'root', password: 'fifthrail2009', insecure: true
      @host = host
    end

    def get_dc(dc_name)
     (dc_name) or fail 'datacenter not found'
    end
  end
end


