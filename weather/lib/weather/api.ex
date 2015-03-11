defmodule Weather.Api do

  require Logger

  @cities %{
    "guadalajara" => "4005539",
    "benghazi"    => "88319"
  }

  @moduledoc """
  Handles request and responses to REST weather service
  """

  @doc """
  Takes city argument and returns a parse response tuple depending on result
  """
  def fetch(city) do
    Logger.info "Fetching weather data for #{city}"
    city |> service_url |> HTTPoison.get() |> handle_response
  end

  defp service_url(city) do
    case @cities[city] do
      nil -> city_not_found(city)
      id  -> "#{Application.get_env(:weather, :service)}?id=#{id}"
    end
  end

  defp handle_response({ :ok, %HTTPoison.Response{ status_code: 200, body: body }}) do
    { :ok, :jsx.decode(body) }
  end

  defp handle_response({ :ok, %HTTPoison.Response{ status_code: status, body: body }}) do
    Logger.error "Error #{status} returned"
    { :error, :jsx.decode(body) }
  end

  defp city_not_found(city) do
    IO.puts "#{city} city not found."
    IO.puts "Try one of this: #{inspect Map.keys(@cities)}"
    System.halt(2)
  end

end
