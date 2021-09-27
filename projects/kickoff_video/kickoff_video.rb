require "cyberarm_engine"
require_relative "lib/slide"
require_relative "lib/slides/slide_intro"
require_relative "lib/slides/slide_zero"
require_relative "lib/slides/slide_one"
require_relative "lib/slides/slide_two"
require_relative "lib/slides/slide_three"

class GosuGameJamLaunchVideo
  class Window < CyberarmEngine::Window
    def setup
      push_state(GosuGameJamLaunchVideo::Slides::SlideIntro)
    end

    def button_down(id)
      super

      close if id == Gosu::KB_ESCAPE
    end
  end
end

GosuGameJamLaunchVideo::Window.new(width: 1920, height: 1080, fullscreen: true).show
