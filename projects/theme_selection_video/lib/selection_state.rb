class GosuGameJamThemeSelectionVideo
  class SelectionState < CyberarmEngine::GameState
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

      @themes = []
      @theme_votes = {}

      File.read("#{File.expand_path("..", __dir__)}/themes.txt").each_line do |line|
        theme = line.strip

        next if theme.start_with?("!#")
        next if theme.length.zero?

        @themes << theme
        @theme_votes[theme] = 0
      end

      @sorted_themes = @themes.clone

      @small_theme_font = Gosu::Font.new(48, name: "TerminessTTF Nerd Font")
      @theme_font = Gosu::Font.new(96, name: "TerminessTTF Nerd Font")

      @theme_selection_time = 10_000 # ms
      @theme_selection_interval = 500 # ms
      @theme_selection_last_interval = Gosu.milliseconds

      @theme_selection_count = 15
      @theme_voting_rounds = 1_000_000
      #                                                    updates per second                              seconds
      @theme_votes_per_cycle = ((@theme_voting_rounds / (((1.0 / window.update_interval) * 1000.0)) / (@theme_selection_time / 1000.0))).round
      @theme_voting_rounds_total = 0
      @theme_selection_columns = 3
      @themes_per_column = (@themes.count / @theme_selection_columns.to_f).ceil
      @widest_theme = @themes.map { |t| @small_theme_font.text_width(t) }.max.ceil

      @born_at = Gosu.milliseconds

      @bg_scale = [@background_image.width / window.width.to_f, @background_image.height / window.height.to_f].max
    end

    def draw
      @background_image.draw(0, 0, -2, @bg_scale, @bg_scale, 0xff_999999)

      _draw_theme_selection_
      # _draw_selected_themes_

      _draw_

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

    def _draw_theme_selection_
      x = window.width / 2 - ((@widest_theme + FRAME_PADDING) * @theme_selection_columns) / 2
      y = window.height / 2 - (@themes_per_column * @small_theme_font.height) / 2

      @sorted_themes.each_slice(@themes_per_column).each_with_index do |themes, column|
        themes.each_with_index do |theme, i|
          theme_width = @small_theme_font.text_width(theme)

          # Shadow
          @small_theme_font.draw_text(
            theme,
            x + 2,
            y + (@small_theme_font.height * i) + 2,
            -1,
            1,
            1,
            0xee_000000
          )

          # Main Text
          @small_theme_font.draw_text(
            theme,
            x,
            y + (@small_theme_font.height * i),
            -1,
            1,
            1,
            0xaa_ffffff
          )
        end

        x += @widest_theme + FRAME_PADDING
      end
    end

    def _draw_selected_themes_
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
          0x88_000000
        )
      end
    end

    def update
      super

      if @theme_voting_rounds_total < @theme_voting_rounds
        @theme_votes_per_cycle.times do
          @themes.sample(@theme_selection_count).each do |theme|
            @theme_votes[theme] += 1
          end

          @theme_voting_rounds_total += 1
        end
      end

      if Gosu.milliseconds - @theme_selection_last_interval >= @theme_selection_interval
        @theme_selection_last_interval = Gosu.milliseconds

        @sorted_themes = sort_themes
      end
    end

    def sort_themes
      themes = @theme_votes.keys
      votes  = @theme_votes.values

      i = -1
      themes.sort_by { i += 1; votes[i] }.reverse
    end
  end
end