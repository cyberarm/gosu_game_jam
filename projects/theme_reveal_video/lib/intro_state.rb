# Menu
class GosuGameJamThemeRevealVideo
  class IntroState < CyberarmEngine::GuiState
    def setup
      banner(
        "Press [SPACE] to start",
        width: 1.0,
        text_align: :center,
        margin_top: 128,
        text_shadow: true,
        text_shadow_size: 4,
        text_shadow_color: 0xff_000000,
        text_border: true,
        text_border_size: 2,
        text_border_color: 0xff_222222
      )

      background 0xff_ffffff
      @background_image = get_image("#{ROOT_PATH}/images/png/background.png")
    end

    def draw
      super

      @background_image.draw(0, 0, 30)

      fill(0xaa_111111, 31)
    end

    def button_down(id)
      push_state(RevealState) if id == Gosu::KB_SPACE
    end
  end
end
