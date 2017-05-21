class PosterSize
  attr_accessor :name, :index

  def initialize(poster)
    short_side = poster.short_side_length
    if    short_side < 70
      @name = 'thumbnail'
      @index = 0
    elsif short_side < 150
      @name = 'small'
      @index = 1
    elsif short_side < 300
      @name = 'medium'
      @index = 3
    elsif short_side < 600
      @name = 'large'
      @index = 4
    elsif short_side < 900
      @name = 'extra_large'
      @index = 5
    else
      @name = 'detailed'
      @index = 6
    end
  end
end
