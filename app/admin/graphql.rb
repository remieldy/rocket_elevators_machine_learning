Trestle.admin(:GraphQl) do
    menu do
      group :management, priority: :last do
        item :GraphQl, icon: "fa fa-bolt"
      end
    end
  
    controller do
      def index
      end
    end
end