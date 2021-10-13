require "cyberarm_engine"
require_relative "lib/intro_state"
require_relative "lib/reveal_state"

class GosuGameJamThemeRevealVideo
  ROOT_PATH = File.expand_path("../..", __dir__)

  class Window < CyberarmEngine::Window
    def setup
      push_state(GosuGameJamThemeRevealVideo::IntroState)
    end

    def button_down(id)
      super

      close if id == Gosu::KB_ESCAPE
    end
  end
end

GosuGameJamThemeRevealVideo::Window.new(width: 1920, height: 1080, fullscreen: true).show
