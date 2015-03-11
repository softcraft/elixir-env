defmodule Weather.Api do

  require Logger

  @cities %{"guadalajara" => "4005539"}

  def fetch(city) do
    Logger.info "Fetching weather data for #{city}"
    @cities[city] |> service_url |> HTTPoison.get() |> handle_response
  end

  def service_url(id) do
    "#{Application.get_env(:weather, :service)}?id=#{id}"
  end

  def handle_response({ :ok, %HTTPoison.Response{ status_code: 200, body: body }}) do
    { :ok, :jsx.decode(body) }
  end

  def handle_response({ :ok, %HTTPoison.Response{ status_code: status, body: body }}) do
    Logger.error "Error #{status} returned"
    { :error, :jsx.decode(body) }
  end

end
