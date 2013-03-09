module Web
class App < Sinatra::Base
  use Faye::RackAdapter, :mount => '/faye', :timeout => 25
  configure do
    set :radio, RadioClient.new
    
    Thread.new do
      while(true) do
        settings.radio.poll
        sleep 5
      end
    end
  end
  
  get '/' do
    settings.radio.status
  end
end
end
