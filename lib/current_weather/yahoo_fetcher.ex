defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

defmodule CurrentWeather.YahooFetcher do
  def fetch(woeid) do
    body = get(woeid)
    temp = extract_temperature(body)
    temp
  end

  defp extract_temperature(body) do
    # Put code here to extract the temperature from the xml
    { xml, _rest } = :xmerl_scan.string(bitstring_to_list(body))
    [ condition ] = :xmerl_xpath.string('/rss/channel/item/yweather:condition/@temp', xml)
    condition.value
  end

  defp get(woeid) do
    {:ok, 200, _headers, client} = :hackney.get(url_for(woeid))
    {:ok, body} = :hackney.body(client)
    body
  end

  defp url_for(woeid) do
    base_url <> woeid
  end

  defp base_url do
    "http://weather.yahooapis.com/forecastrss?w="
  end
end
