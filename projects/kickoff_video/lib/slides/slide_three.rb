# Pong background: What will you create? outro

# What can you make with gosu?
class GosuGameJamLaunchVideo
  class Slides
    class SlideThree < Slide
      def setup
        @born_time = Gosu.milliseconds

        background_color(Gosu::Color::WHITE)
        background_image(:background)

        @overlay_color = 0x44_222222

        @gosu_game_jam_logo = slide_image(:gosu_game_jam_logo_large)

        @typewriter_text = slide_text(
          "",
          font: "TerminessTTF Nerd Font",
          size: 144,
          color: Gosu::Color::BLACK,
          shadow: true,
          shadow_color: Gosu::Color::WHITE,
          shadow_size: 2
        )

        @typewriter_final_message = "What will you\ncreate?"

        @typewriter_text_final_width = @typewriter_text.textobject.text_width(@typewriter_final_message)

        @gosu_game_jam_logo_scale = 0.25

        @gosu_game_jam_logo_position = CyberarmEngine::Vector.new(
          window.width - (@gosu_game_jam_logo.width * @gosu_game_jam_logo_scale) / 2 - (FRAME_PADDING + FRAME_THICKNESS * 2),
          (FRAME_PADDING + FRAME_THICKNESS * 2) + (@gosu_game_jam_logo.height * @gosu_game_jam_logo_scale) / 2,
          10
        )

        @typewriter_text.x = window.width / 2 - @typewriter_text_final_width * 0.7
        @typewriter_text.y = window.height * 0.65 - @typewriter_text.height / 2

        @typewriter_text_animator = CyberarmEngine::Animator.new(
          start_time: @born_time,
          duration: 3_000,
          from: 0.0,
          to: 1.0,
          tween: :ease_in_out
        )
      end

      def draw
        super

        fill(@overlay_color)

        Gosu.rotate(-15) do
          @typewriter_text.draw
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

      def update
        super

        @typewriter_text.x = window.width / 2 - @typewriter_text_final_width * 0.7
        @typewriter_text.y = window.height * 0.65 - @typewriter_text.height / 2

        chars = (@typewriter_final_message.length * @typewriter_text_animator.transition).floor
        @typewriter_text.text = @typewriter_final_message[0..chars]

        push_state(SlideFour) if Gosu.milliseconds - @born_time >= 5_000
      end
    end
  end
end
