defmodule Weather.CLI do

  @default_city "guadalajara"

  def main(argv) do
    argv |> parse_args |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean], aliases: [h: :help])
    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ city ], _       } -> city
      _                        -> @default_city
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather [ city | #{@default_city} ]
    """
    System.halt(0)
  end

  def process(city) do
    Weather.Api.fetch(city)
    |> decode_response
    |> print_result(city)
  end

  def decode_response({ :ok, body }), do: body
  def decode_response({ :error, error }) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def print_result(list, city) do
    {"main", main} = List.keyfind(list, "main", 0)
    {"temp", temp} = List.keyfind(main, "temp", 0)

    IO.puts "Temperature in #{city} is #{temp - 273.15} Celcius"
  end

end
