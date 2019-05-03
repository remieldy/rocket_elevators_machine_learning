require 'azure/storage/blob'
require 'net/http'
require 'uri'
require 'json'
require 'openssl'



Trestle.admin(:cognitive) do
    menu do
      group :informations, priority: :last do
      item :cognitive, icon: "fa fa-tachometer"
      end
    end
  
    controller do

      skip_before_action :verify_authenticity_token

      def index
        
      end

      def wait(http)

        get1(http)

        if @status.empty? 

          p "caliss"

          wait(http)
        
        else 

          p "--------------------------------"
          p @status["channel_0"]
          p "--------------------------------"

          display(http)

        end

      end

      #Second api call for a get
      def get1(http)

        url = URI("#{@azurelink}")

        p "--------------------------------"
        p url
        p "--------------------------------"

        request = Net::HTTP::Get.new(url)
        request["Ocp-Apim-Subscription-Key"] = '759435af27c74cf1b2500edbb9eb51d6'
        request["Content-Type"] = "application/json"

        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        p 'requete GET'
        response = http.request(request)

        p '-----------------------------'
        @body = JSON.parse(response.body)
        p @body
        p '-----------------------------'

        p '-----------------------------'
        @status = @body['resultsUrls']
        p @status
        p '-----------------------------'

      end

      def upload
        
        pp params[:uploadfile]

        blob_client = Azure::Storage::Blob::BlobService.create(
          storage_account_name: 'respeechtotextstorage',
          storage_access_key: 'Wg77GNweuHNW3KUhOGALAQMZhiDP4tmfsqkbah21DbSCumDvQ/9PX2LOZISx3B8sKAFUbQpefSP3vx0XV1T1Ng=='
        )
        
        if params[:uploadfile] != nil

        
          @language = params[:position]

          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"
          p "--------------------------------------------------"

          p @language
    
          file_to_upload = params[:uploadfile].read

          blob_name = params[:uploadfile].original_filename

          p blob_name
          container_name = 'rocketconversations'

          # Upload file as a block blob
          puts 'Uploading BlockBlob'
      
          # Get full path on drive to file_to_upload
          blob_client.create_block_blob('rocketconversations', "blob_name", file_to_upload, content_type: 'audio/wav')

          Time.new
          sleep 3

          #first get to api
          url = URI("https://westus.cris.ai/api/speechtotext/v2.0/transcriptions")

          http = Net::HTTP.new(url.host, url.port)
          
          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = 'application/json'
          request["Ocp-Apim-Subscription-Key"] = '759435af27c74cf1b2500edbb9eb51d6'
          request["User-Agent"] = 'PostmanRuntime/7.11.0'
          request["Accept"] = '*/*'
          request["Cache-Control"] = 'no-cache'
          request["Postman-Token"] = '9dfbfcb4-6665-40f8-8aa7-ef15ba9591b6,aa9269b6-983d-4816-9cb3-0b976e1806c7'
          request["Host"] = 'westus.cris.ai'
          request["cookie"] = 'ARRAffinity=c9c5ac10a2a3acce64c4c83492d4e994359e3ba79b70d407cb71e2dcd6449249'
          request["accept-encoding"] = 'gzip, deflate'
          request["content-length"] = '361'
          request["Connection"] = 'keep-alive'
          request["cache-control"] = 'no-cache'
          request.body = "{\n \"recordingsUrl\": \"https://respeechtotextstorage.blob.core.windows.net/rocketconversations/#{blob_name}\",\n \"models\": [],\n \"locale\": \"#{@language}\",\n \"name\": \"Transcription using locale en-US\",\n \"description\": \"An optional description of the transcription.\",\n \"properties\": {\n   \"ProfanityFilterMode\": \"Masked\",\n   \"PunctuationMode\": \"DictatedAndAutomatic\"\n }\n}"
          
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          p 'requete POST'
          response = http.request(request)

          p 'body'
          puts response.read_body
   
          @azurelink = response.header["Location"]
          puts @azurelink

          wait(http)
          
        end
                             
      end

      def display(http)

        url = URI(@status["channel_0"])

        p url

        http = Net::HTTP.new(url.host, url.port)

        request = Net::HTTP::Get.new(url)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        response = http.request(request)
        puts response.read_body

        @audiotxt = JSON.parse(response.body)

        p @audiotxt

        @script = @audiotxt['AudioFileResults'][0]['SegmentResults']
        @transcript = []

        for x in @script do
          @transcript << x['NBest'][0]['Lexical']
        end
        
        render json: { transcript: @transcript }

      end

    end

    routes do 
      post :upload
    end
  end