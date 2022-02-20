class GosuGameJamThemeRevealVideo
  class RevealState < CyberarmEngine::GameState
    FRAME_PADDING = 32
    FRAME_THICKNESS = 4

    def setup
      @background_color = Gosu::Color::BLACK
      @background_image = get_image("#{ROOT_PATH}/images/png/background.png")

      @gosu_game_jam_logo = get_image("#{ROOT_PATH}/images/png/gosu_game_jam_logo_large.png")

      @gosu_game_jam_logo_scale = 0.25

      @gosu_game_jam_logo_position = CyberarmEngine::Vector.new(
        window.width - (@gosu_game_jam_logo.width * @gosu_game_jam_logo_scale) / 2 - (FRAME_PADDING + FRAME_THICKNESS * 2),
        (FRAME_PADDING + FRAME_THICKNESS * 2) + (@gosu_game_jam_logo.height * @gosu_game_jam_logo_scale) / 2,
        10
      )

      @themes = [
        "Summer", #       1
        "Perspective", #  3
        "Steampunk", #    3
        "Slippery", #     3
        "Grim", #         5
        "Growing", #      5
        "Dessert", #      6
        "Racing", #       6
        "Don't Touch", #  7
        "Ruby", #         7
        "Construction", # 8
        "Logic", #        8
        "Adventure", #    8
        "Ant", #          10
        "Castles", #      12
      ]

      @theme_index = 0

      @theme_selector_animator_done = false
      @selector_color = 0xff_000088

      @theme_font = Gosu::Font.new(96, name: "TerminessTTF Nerd Font")

      @born_at = Gosu.milliseconds
      @blink_interval = 500
      @last_blick_trigger = 0

      @blick_width = 64

      @select_interval = 1_000
      @last_select_trigger = 0

      @rotator_animator = CyberarmEngine::Animator.new(
        start_time: @born_at + @blink_interval * 5,
        duration: 1_500,
        from: 0.0,
        to: 90
      )

      @split_animator = CyberarmEngine::Animator.new(
        start_time: @born_at + @blink_interval * 8,
        duration: 1_500,
        from: 0.0,
        to: 1.0,
        tween: :bounce
      )

      @theme_selector_animator = CyberarmEngine::Animator.new(
        start_time: @born_at + @blink_interval * 11,
        duration: 1_000,
        from: 0.0,
        to: 1.0,
        tween: :ease_in_out
      )

      @span = 640

      @bg_scale = [@background_image.width / window.width.to_f, @background_image.height / window.height.to_f].max

      @circle_color = 0xff_888888
    end

    def draw
      @background_image.draw(0, 0, -2, @bg_scale, @bg_scale, 0xff_999999)

      if @rotator_animator.complete?
        _draw_themes_

        unless @split_1
          frame = Gosu.render(window.width, window.height) do
            _draw_
          end

          @split_1 = frame.subimage(0, 0, window.width / 2, window.height)
          @split_2 = frame.subimage(window.width / 2, 0, window.width / 2, window.height)
        end

        @split_1.draw(0 - (@span * @split_animator.transition), 0, 0)
        @split_2.draw(@split_1.width + (@span * @split_animator.transition), 0, 0)
      end

      _draw_ unless @rotator_animator.complete?

      @gosu_game_jam_logo.draw_rot(
        @gosu_game_jam_logo_position.x,
        @gosu_game_jam_logo_position.y,
        @gosu_game_jam_logo_position.z,
        0,
        0.5,
        0.5,
        @gosu_game_jam_logo_scale,
        @gosu_game_jam_logo_scale
      )
    end

    def _draw_
      @background_image.draw(0, 0, -2, @bg_scale, @bg_scale, Gosu::Color::GRAY)

      Gosu.rotate(@rotator_animator.transition, window.width / 2, window.height / 2) do
        if Gosu.milliseconds - @born_at >= @blink_interval
          Gosu.draw_circle(window.width / 2 - @blick_width * 3, window.height / 2, @blick_width, 128, @circle_color)
        end

        if Gosu.milliseconds - @born_at >= @blink_interval * 2
          Gosu.draw_circle(window.width / 2, window.height / 2, @blick_width, 128, @circle_color)
        end

        if Gosu.milliseconds - @born_at >= @blink_interval * 3
          Gosu.draw_circle(window.width / 2 + @blick_width * 3, window.height / 2, @blick_width, 128, @circle_color)
        end
      end

      Gosu.draw_rect(
        FRAME_PADDING, FRAME_PADDING,
        window.width - FRAME_PADDING * 2, FRAME_THICKNESS,
        Gosu::Color::BLACK
      )
      Gosu.draw_rect(
        window.width - (FRAME_PADDING + FRAME_THICKNESS), FRAME_PADDING,
        FRAME_THICKNESS, window.height - FRAME_PADDING * 2,
        Gosu::Color::BLACK
      )
      Gosu.draw_rect(
        FRAME_PADDING, window.height - (FRAME_PADDING + FRAME_THICKNESS),
        window.width - FRAME_PADDING * 2, FRAME_THICKNESS,
        Gosu::Color::BLACK
      )
      Gosu.draw_rect(
        FRAME_PADDING, FRAME_PADDING,
        FRAME_THICKNESS, window.height - FRAME_PADDING * 2,
        Gosu::Color::BLACK
      )
    end

    def _draw_themes_
      @themes.each_with_index do |theme, i|
        theme_width = @theme_font.text_width(theme)

        # Shadow
        @theme_font.draw_text(
          theme,
          window.width / 2 - theme_width / 2 + 2,
          (window.height / 2 - @theme_font.height / 2) + (@theme_font.height * (i - @theme_index)) + 2,
          -1,
          1,
          1,
          0x88_ffffff
        )

        # Main Text
        @theme_font.draw_text(
          theme,
          window.width / 2 - theme_width / 2,
          (window.height / 2 - @theme_font.height / 2) + (@theme_font.height * (i - @theme_index)),
          -1,
          1,
          1,
          @theme_index == i ? @selector_color : 0x88_000000
        )
      end

      theme_width = @theme_font.text_width(@themes[@theme_index])

      Gosu.draw_triangle(
        window.width / 2 - (theme_width / 2 + @theme_font.height * 1.5),
        window.height / 2 - @theme_font.height / 2,
        @selector_color,
        window.width / 2 - (theme_width / 2 + @theme_font.height * 0.5),
        window.height / 2,
        @selector_color,
        window.width / 2 - (theme_width / 2 + @theme_font.height * 1.5),
        window.height / 2 + @theme_font.height / 2,
        @selector_color,
        -1
      )

      @selector_color = 0xff_000088 if @theme_selector_animator.progress > 0.25
      @selector_color = Gosu.milliseconds % 500 <= 250 ? 0xff_000088 : 0xff_000044 if @theme_selector_animator_done
    end

    def update
      if @theme_selector_animator.complete?
        @theme_index += 1

        if @theme_index >= @themes.size - 1
          @theme_selector_animator_done = true
          @theme_index = @themes.size - 1
        else
          @theme_selector_animator.instance_variable_set("@start_time", Gosu.milliseconds)
          @selector_color = 0xff_000044
        end
      end
    end
  end
end
