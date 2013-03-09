=begin
  Most periodic tasks need to be run both now 
  and after a specificed time period.
  
  This Eventmachine helper does that. You can
  specify the timeframe in hours, minutes or 
  seconds.
=end

module EventMachine
  def self.now_and_every(period, &blk)
    yield
  
    seconds = case
      when period.include?(:hours)
        period[:hours]*60*60
      when period.include?(:minutes)
        period[:minutes]*60
      else
        period[:seconds]
    end
  
    EM::Synchrony.add_periodic_timer(seconds) do
      yield
    end
  end
end