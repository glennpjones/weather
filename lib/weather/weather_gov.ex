defmodule Weather.WeatherGov do

  require Logger
  import SweetXml
 
  @base_url "http://w1.weather.gov/xml/current_obs/"
  @moduledoc """
  Handle the getting and parsing of data from weather.gov
  """

  def fetch do
    url = weather_gov_url
    |> HTTPoison.get
    |> decode_response
    |> parse_xml
    |> format_weather_result
  end

  def format_weather_result(%{location: location, weather: weather, wind: wind}) do
    IO.puts "The weather in #{location} is #{dcase(weather)}, with a #{dcase(wind)} wind."
  end

  def dcase(charlist), do: charlist |> to_string |> String.downcase

  def parse_xml(response) do
    response
    |> xpath(
      ~x"//current_observation",
      location: ~x"./location/text()",
      weather: ~x"./weather/text()",
      wind: ~x"./wind_string/text()" )
  end

  def decode_response( {:ok, %HTTPoison.Response{status_code: 200, body: body}} ) do
    Logger.info "Successfull response"
    Logger.debug fn -> inspect(body) end
    body
  end

  def weather_gov_url do
    "#{@base_url}KDTO.xml"
  end

  def weather_gov_url(place) do
    "#{@base_url}#{place}.xml"
  end
  
end
