defmodule Weather.CLI do

  @default_city "guadalajara"

  @moduledoc """
  Handle the command line parsing and the dispatch to the various
  functions to print in screen the result of weather in  end to print
  in screen the result of weather in guadalajara
  """

  @doc """
  Main function that takes command line args and process them
  """
  def main(argv) do
    argv |> parse_args |> process
  end

  defp parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean], aliases: [h: :help])
    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ city ], _       } -> city
      _                        -> @default_city
    end
  end

  defp process(:help) do
    IO.puts """
    usage: weather [ city | #{@default_city} ]
    """
    System.halt(0)
  end

  defp process(city) do
    Weather.Api.fetch(city)
    |> decode_response
    |> print_result(city)
  end

  defp decode_response({ :ok, body }), do: body
  defp decode_response({ :error, error }) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching weather service: #{message}"
    System.halt(2)
  end

  defp print_result(list, city) do
    {"main", main} = List.keyfind(list, "main", 0)
    {"temp", temp} = List.keyfind(main, "temp", 0)

    IO.puts "Temperature in #{city} is #{temp - 273.15} Celcius"
  end

end
