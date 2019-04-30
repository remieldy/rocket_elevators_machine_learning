Trestle.admin(:cognitive) do
    menu do
      group :informations, priority: :last do
      item :cognitive, icon: "fa fa-tachometer"
      end
    end
  
    controller do
      def index
      end
    end
  end