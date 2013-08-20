require 'forwardable'
require 'logging'
require 'event_binding'
require 'playlist_sync'

class Radiodan
class Player
  extend Forwardable
  include Logging
  include EventBinding
  
  attr_reader :adapter, :playlist, :playlist_changed
  def_delegators :adapter, :stop
  
  def adapter=(adapter)
    @adapter = adapter
    @adapter.player = self
  end
  
  def adapter?
    !adapter.nil?
  end
  
  def playlist=(new_playlist)
    @playlist = new_playlist
    trigger_event(:playlist, @playlist)
    # run sync to explicitly conform to new playlist?
    @playlist_changed = true    
    @playlist
  end
  
  def state
    adapter.playlist
  end
  
=begin
  Sync checks the current status of the player.
  Is it paused? Playing? What is it playing?
  It compares the expected to actual statuses and
  makes changes required to keep them the same.
=end
  def sync
    return false unless adapter?

    current  = adapter.playlist
    expected = playlist

    sync = Radiodan::PlaylistSync.new expected, current

    # once the playlist has changed it needs to be triggered *after* the first sync, hence this.
    if(@playlist_changed)
      logger.debug "Playlist changed, triggering event playlist_changed"
      trigger_event :playlist_changed, state
      @playlist_changed = false
    end

    if sync.sync?
      true
    else
      # playback state
      if sync.errors.include? :state
        logger.debug "Expected: #{expected.state} Got: #{current.state}"
        trigger_event :play_state, expected.state
      end
      
      if sync.errors.include? :mode
        logger.debug "Expected: #{expected.mode} Got: #{current.mode}"
        trigger_event :play_mode, expected.mode
      end
      
      # playlist
      if sync.errors.include? :playlist
        logger.debug "Expected: #{expected.current} Got: #{current.current}"
        trigger_event :playlist, expected
      end
      
      false
    end
  end
end
end
