require 'socket'

module Web
  class RadioClient
    SocketFile = File.join(File.dirname(__FILE__), '../../tmp/socket')
    attr_reader :status
    
    def initialize
      # this is where we setup sockets?
      @status = 'hello'
      connect!
    end
    
    def poll
      while chunk = @socket.gets
        @status += chunk
      end
    end
    
    private
    def connect!
      @socket = UNIXSocket.new('/tmp/file.sock')
    end
  end
end
