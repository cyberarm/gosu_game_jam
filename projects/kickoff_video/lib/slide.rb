class GosuGameJamLaunchVideo
  class Slides
    FRAME_PADDING = 32
    FRAME_THICKNESS = 4
  end

  class Slide < CyberarmEngine::GameState
    ROOT_PATH = File.expand_path("../../..", __dir__)

    def setup
      @background_color = Gosu::Color::BLACK
      @background_image = nil
    end

    def draw
      fill(@background_color)
      @background_image&.draw(0, 0, 0)
    end

    def update
    end

    def background_color(color)
      @background_color = color
    end

    def background_image(image_name)
      @background_image = slide_image(image_name)
    end

    def slide_text(text, hash = {})
      CyberarmEngine::Text.new(text, **hash)
    end

    def slide_image(image_name)
      get_image("#{ROOT_PATH}/images/png/#{image_name}.png")
    end
  end
end
