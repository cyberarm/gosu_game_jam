# Menu
class GosuGameJamLaunchVideo
  class Slides
    class SlideIntro < CyberarmEngine::GameState
      def setup
      end

      def button_down(id)
        push_state(SlideZero) if id == Gosu::KB_SPACE
      end
    end
  end
end
