require "rest-client"
require 'open_weather'
require 'net/http'
require 'rest-client'
require 'rspotify'


class Streamer 

    def getContent(type='weather')

        getHtmlFromCloud(type)

    end

    def getHtmlFromCloud(type)
        if type == 'weather'  
          return "<div>#{JSON.parse(self.GetCurrentWeather)['description']['main']}</div>"
        end 

        if type == "forecast"
            return "<div>#{JSON.parse(self.getSpotify)}</div>" 
        end
    end

    def getCurrentWeather
        # get current weather by city name
        options = { units: "metric", APPID: ENV["openweather"] }
        OpenWeather::Current.city("Montreal, CA", options)
    end


    def getSpotify
        connecting = RSpotify.authenticate(ENV['spotifyid'], ENV['spotifysecret'])
        playlist = RSpotify::Playlist.find('sam2019','0urVehkCOe7mge5h9q5oMF')
        playlistName = playlist.name
    end

end

