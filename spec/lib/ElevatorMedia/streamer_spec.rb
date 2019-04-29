require 'ElevatorMedia/Streamer'
require 'net/http'


describe 'Streamer' do
    
    let!(:streamer){Streamer.new}

    it "A passing test" do
        expect(true).to be true
    end

    it "Should respond to getContent" do
        expect(streamer).to respond_to(:getContent)        
    end

    describe 'Quebec weather' do 

        it 'Current Weather' do
            expect(OpenWeather::Current).to receive(:city){'good'}
            currentWeather = streamer.getCurrentWeather
            expect(currentWeather).to_not eq(nil)
        end

        it "Check weather objet" do
            result = streamer.getCurrentWeather()
            expect(result).to be_an(Object)
            p result
        end

        it "should get weather from internet" do
            expect(streamer).to receive(:getHtmlFromCloud)
            streamer.getContent()
        end

    end

    describe 'Spotify' do


        it 'Check if spotify exist'do
            expect(streamer).to respond_to(:getSpotify) 
        end


        it 'Current spotify' do
            currentsong = streamer.getSpotify
            expect(currentsong).to_not eq(nil)
        end


        it "Check spotify object" do
            result = streamer.getSpotify()
            expect(result).to be_an(Object)
            p result
        end

    end
end