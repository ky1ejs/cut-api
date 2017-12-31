ActiveAdmin.register_page "Flixster Data" do
  belongs_to :film

  controller do
    def resource
      Film.find(params[:film_id])
    end
  end

  content do
    provder = FilmProvider.find_by(provider: :flixster, film_id: resource.id)
    Flixster::Provider.get_film_json_with_id(provder.provider_film_id)
  end
end
