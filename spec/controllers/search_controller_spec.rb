require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  it 'search for films that have not be retrieved from flixster yet' do
    expect(Film.all.count).to eq 0

    id = '12345678'
    title = "Interstellar"
    search_json = [{:id => id}]
    film_json = create(:flixster_film_json, id: id, title: title)

    stub_request(:get, Regexp.new("#{FlixsterController.movies_url}")).to_return(status: 200, body: search_json.to_json)
    stub_request(:get, Regexp.new("#{FlixsterController.movies_url}/#{id}.json")).to_return(status: 200, body: film_json.to_json)

    request.headers[:HTTP_DEVICE_ID] = create(:device).device_id
    get :search, params: {:term => title}
    response_json = JSON.parse(response.body)
    films = response_json['films']

    expect(films.count).to eq 1
    expect(Film.all.count).to eq 1
    expect(films.first['id']).to eq Film.all.first.id
  end

  it 'does not search flixster if films our found in db' do
    expect(Film.all.count).to eq 0

    f = create(:flixster_film)

    WebMock.reset!

    request.headers[:HTTP_DEVICE_ID] = create(:device).device_id
    get :search, params: {:term => f.title}
    response_json = JSON.parse(response.body)
    films = response_json['films']

    expect(films.count).to eq 1
    expect(Film.all.count).to eq 1
    expect(f.title).to eq films.first['title']
    expect(f.id).to eq films.first['id']
  end
end
