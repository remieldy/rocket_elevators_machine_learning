require 'azure/storage/blob'


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

      def upload
        
        pp params[:uploadfile]

        blob_client = Azure::Storage::Blob::BlobService.create(
          storage_account_name: 'respeechtotextstorage',
          storage_access_key: 'Wg77GNweuHNW3KUhOGALAQMZhiDP4tmfsqkbah21DbSCumDvQ/9PX2LOZISx3B8sKAFUbQpefSP3vx0XV1T1Ng=='
        )
        
    
        file_to_upload = params[:uploadfile].read

        
        blob_name = params[:uploadfile]

        p blob_name
        container_name = 'rocketconversations'

        # Upload file as a block blob
        puts 'Uploading BlockBlob'
    
        # Get full path on drive to file_to_upload
        blob_client.create_block_blob('rocketconversations', "blob_name", file_to_upload, content_type: 'audio/wav')
                                    
      end

    end

    routes do 
      post :upload
    end
  end