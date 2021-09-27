# Games Showcase
class GosuGameJamLaunchVideo
  class Slides
    class SlideTwo < Slide
      def setup
        @born_time = Gosu.milliseconds
        @card_interval = 5_000
        @card_last_changed = @born_time# + @card_interval

        @background_color = 0xaa_000080

        @card_background_image = slide_image(:background)

        @game_name_font = Gosu::Font.new(72, name: "TerminessTTF Nerd Font")
        @author_font = Gosu::Font.new(48, name: "TerminessTTF Nerd Font")

        @showcase = [
          {
            game_name: "GAME ONE",
            author: "AUTHOR ONE",
            background: 0xff_000080
          },
          {
            game_name: "GAME TWO",
            author: "AUTHOR TWO",
            background: 0xff_008000
          },
          {
            game_name: "GAME THREE",
            author: "AUTHOR THREE",
            background: 0xff_800000
          }
        ]

        @cards = []
        @card_index = 0

        @showcase.each do |hash|
          @cards << generate_card(hash[:game_name], hash[:author])
        end

        @out_going_animator = CyberarmEngine::Animator.new(
          start_time: @born_time,
          duration: 1_000,
          from: 0.0,
          to: 1.0,
          tween: :ease_in_out
        )

        @in_going_animator = CyberarmEngine::Animator.new(
          start_time: @born_time + 4_000,
          duration: 1_000,
          from: 0.0,
          to: 1.0,
          tween: :ease_in_out
        )
      end

      def draw
        super

        card = @cards[@card_index]
        animator = @out_going_animator.complete? ? 1.0 - @in_going_animator.transition : @out_going_animator.transition

        fill(@showcase[@card_index][:background])

        Gosu.translate(-card.width + (card.width * animator), 0) do
          card.draw_as_quad(
            0, window.height / 2, Gosu::Color::WHITE,
            card.width, window.height / 2, Gosu::Color::WHITE,
            card.width, window.height / 2 + card.height, Gosu::Color::WHITE,
            0, window.height / 2 + card.height, Gosu::Color::WHITE,
            1
          )
        end
      end

      def update
        super

        if Gosu.milliseconds - @card_last_changed >= @card_interval
          @card_last_changed = Gosu.milliseconds

          @out_going_animator.instance_variable_set(:"@start_time", Gosu.milliseconds)
          @in_going_animator.instance_variable_set(:"@start_time", Gosu.milliseconds + (@card_interval - @in_going_animator.instance_variable_get(:"@duration")))

          @card_index += 1
        end

        push_state(SlideThree) if @card_index >= @cards.size
      end

      def generate_card(game_name, author)
        width = 512
        height = 128

        padding_x = 32
        padding_y = 0
        shadow_size = 2

        Gosu.render(width, height) do
          @card_background_image.draw(0, 0, 0)

          @game_name_font.draw_text(game_name, padding_x + shadow_size, padding_y + shadow_size, 0, 1, 1, Gosu::Color::WHITE)
          @game_name_font.draw_text(game_name, padding_x, padding_y, 0, 1, 1, Gosu::Color::BLACK)

          @author_font.draw_text(author, padding_x + shadow_size, padding_y + @game_name_font.height + shadow_size, 0, 1, 1, Gosu::Color::WHITE)
          @author_font.draw_text(author, padding_x, padding_y + @game_name_font.height, 0, 1, 1, Gosu::Color::BLACK)

          Gosu.draw_rect(width - 8, 0, 8, height, 0x88_000000)
        end
      end
    end
  end
end
