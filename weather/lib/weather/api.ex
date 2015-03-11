defmodule Weather.Api do

  require Logger

  def fetch(city) do
    Logger.info "Fetching weather data"
    #TODO: Use param city to fetch city dinamically
    Application.get_env(:weather, :guadalajara) |> HTTPoison.get() |> handle_response
  end

  def handle_response({ :ok, %HTTPoison.Response{ status_code: 200, body: body }}) do
    Logger.info "Succesful response"
    { :ok, :jsx.decode(body) }
  end

  def handle_response({ :ok, %HTTPoison.Response{ status_code: status, body: body }}) do
    Logger.error "Error #{status} returned"
    { :error, :jsx.decode(body) }
  end

end
