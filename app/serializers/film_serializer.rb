class FilmSerializer < ActiveModel::Serializer
  attributes  :id,
              :title,
              :posters,
              :trailers,
              :relative_theater_release_date,
              :theater_release_date,
              :running_time,
              :synopsis,
              :ratings

  def posters
    return if object.posters.count == 0

    grouped_posters = object.posters.group_by { |poster| poster.size_index }
    posters = grouped_posters.map { |k, v| v.sort_by { |poster| poster.short_side_length } }
    posters = posters.map { |g| g.last } # get the biggest for each size group

    size_sorted_posters = object.posters.sort_by { |poster| poster.short_side_length }
    smallest_poster = size_sorted_posters.first
    largest_poster = size_sorted_posters.last

    poster_json = {}
    posters.each { |p| poster_json[p.size_name] = PosterSerializer.new(p).serializable_hash }
    poster_json['smallest'] = PosterSerializer.new(smallest_poster).serializable_hash
    poster_json['largest'] = PosterSerializer.new(largest_poster).serializable_hash

    profile_poster = poster_json['large']
    if profile_poster == nil
      all_posters = grouped_posters.values.flatten
      profile_poster = all_posters.first
      all_posters.each do |poster|
        if poster.short_side_length > 500
          next
        end
        if  profile_poster.short_side_length < poster.short_side_length
          profile_poster = poster
        end
      end
    end
    poster_json['profile'] = profile_poster

    hero_poster = poster_json['extra_large']
    if hero_poster == nil
      all_posters = grouped_posters.values.flatten
      hero_poster = all_posters.first
      all_posters.each do |poster|
        next if poster.short_side_length > 1000
        hero_poster = poster if hero_poster.short_side_length < poster.short_side_length
      end
    end
    poster_json['hero'] = hero_poster

    poster_json
  end

  def trailers
    trailers = {}
    object.trailers.each { |t| trailers[t.quality] = TrailerSerializer.new(t).serializable_hash }
    trailers
  end

  def relative_theater_release_date
    object.theater_release_date.relative_time_string unless object.theater_release_date == nil
  end

  def ratings
    object.ratings.each { |r| RatingSerializer.new(r).serializable_hash }
  end
end
