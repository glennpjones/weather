defmodule Weather do

  require Logger

  def main(argv) do
    Logger.debug "The given arguments are: #{argv}"
    argv
    |> parse_args
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean])
    case parse do
      { [help: true], _, _}
      -> help
      {_, ["Weather"], _}
      -> process
      {_, _, _}
      -> help
    end
  end

  def process do
    Weather.WeatherGov.fetch
  end

  def help do
    IO.puts "Type 'Weather' to get output"
  end

end
