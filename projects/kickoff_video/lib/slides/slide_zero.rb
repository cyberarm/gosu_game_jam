class GosuGameJamLaunchVideo
  class Slides
    class SlideZero < Slide
      def setup
        @born_time = Gosu.milliseconds

        background_color(Gosu::Color::WHITE)
        background_image(:background)

        @overlay_color = 0x44_222222

        @gosu_game_jam_logo = slide_image(:gosu_game_jam_logo_large)
        @inaugural_text = slide_text(
          "Inaugural",
          font: "TerminessTTF Nerd Font",
          size: 196,
          color: Gosu::Color::BLACK,
          shadow: true,
          shadow_color: Gosu::Color::WHITE,
          shadow_size: 2
        )

        @gosu_game_jam_logo_position = CyberarmEngine::Vector.new(
          window.width / 2,
          window.height / 2,
          10
        )

        @gosu_game_jam_logo_end_scale = 0.25

        @gosu_game_jam_logo_end_position = CyberarmEngine::Vector.new(
          window.width - (@gosu_game_jam_logo.width * @gosu_game_jam_logo_end_scale) / 2 - (FRAME_PADDING + FRAME_THICKNESS * 2),
          (FRAME_PADDING + FRAME_THICKNESS * 2) + (@gosu_game_jam_logo.height * @gosu_game_jam_logo_end_scale) / 2,
          10
        )

        @gosu_game_jam_logo_animator = CyberarmEngine::Animator.new(
          start_time: @born_time,
          duration: 2_000,
          from: -1.5,
          to: 1.0,
          tween: :swing_from_to
        )

        @inaugural_text_animator = CyberarmEngine::Animator.new(
          start_time: @born_time + 500,
          duration: 1_750,
          from: -2.0,
          to: 1.0,
          tween: :swing_from_to
        )

        @gosu_game_jam_logo_end_animator = CyberarmEngine::Animator.new(
          start_time: @born_time + 4_000,
          duration: 1_000,
          from: 0.0,
          to: 1.0,
          tween: :ease_in_out
        )
      end

      def draw
        super

        fill(@overlay_color)

        unless @gosu_game_jam_logo_animator.complete?
          @gosu_game_jam_logo.draw_rot(
            @gosu_game_jam_logo_position.x,
            @gosu_game_jam_logo_position.y * @gosu_game_jam_logo_animator.transition,
            @gosu_game_jam_logo_position.z
          )
        else
          @gosu_game_jam_logo.draw_rot(
            ((@gosu_game_jam_logo_end_position.x - @gosu_game_jam_logo_position.x) * @gosu_game_jam_logo_end_animator.transition) + @gosu_game_jam_logo_position.x,
            ((@gosu_game_jam_logo_end_position.y - @gosu_game_jam_logo_position.y) * @gosu_game_jam_logo_end_animator.transition) + @gosu_game_jam_logo_position.y,
            @gosu_game_jam_logo_position.z,
            0,
            0.5,
            0.5,
            (1.0 - @gosu_game_jam_logo_end_animator.transition).clamp(0.25, 1.0),
            (1.0 - @gosu_game_jam_logo_end_animator.transition).clamp(0.25, 1.0)
          )
        end

        @inaugural_text.draw

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

      def update
        super

        @inaugural_text.x = window.width / 2 - @inaugural_text.width / 2

        unless @inaugural_text_animator.complete?
          @inaugural_text.y = (window.height / 2 - @gosu_game_jam_logo.height) * @inaugural_text_animator.transition
        else
          base_y = window.height / 2 - @gosu_game_jam_logo.height
          target_y = -@inaugural_text.height * 2

          @inaugural_text.y = ((target_y - base_y) * @gosu_game_jam_logo_end_animator.transition) + base_y
        end

        push_state(SlideOne) if Gosu.milliseconds - @born_time >= 5_000
      end
    end
  end
end
