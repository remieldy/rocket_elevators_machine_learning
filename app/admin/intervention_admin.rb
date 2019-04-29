Trestle.admin(:intervention) do
    menu do
      group :intervention, priority: :last do
        item :create_intervention, icon: "fa fa-tachometer"
      end
    end

    controller do
    # GET /interventions
    # GET /interventions.json
    def index
      @interventions = Intervention.all

      session[:user] = "#{current_user.first_name} #{current_user.last_name}"
    
    end

    # GET /interventions/1
    # GET /interventions/1.json
    def show
    end

    # Get customer building id

    def getbuilding

      if params[:customer].present?

        @buildings = Customer.find(params[:customer]).buildings

        @customername = Customer.find(params[:customer]).company_name

        session[:companyname] = @customername

      else
        @buildings = Building.all
      end

      render json: @buildings
    end

    # Get customer battery id

    def getbattery

      if params[:building].present?

        @batteries = Building.find(params[:building]).batteries
      else
        @batteries = Battery.all
      end

      render json: @batteries
    end

    # Get customer column

    def getcolumn

      if params[:battery].present?

        @Columns = Battery.find(params[:battery]).columns
      else
        @Columns = Column.all
      end

      render json: @Columns
    end

    # Get customer elevator

    def getelevator

      if params[:column].present?

        @Elevators = Column.find(params[:column]).elevators
      else
        @Elevators = Elevator.all
      end

      render json: @Elevators
    end
  
    # GET /interventions/new
    def new
      @intervention = Intervention.new
    end

    # GET /interventions/1/edit
    def edit
    end

    # POST /interventions
    # POST /interventions.json
    def create

      @intervention = Intervention.new()

      @intervention.author = session[:user]
      @intervention.customer_id = params[:customer_id]
      @intervention.building_id = params[:building_id]
      @intervention.battery_id = params[:battery_id]
      @intervention.column_id = params[:column_id]
      @intervention.elevator_id = params[:elevator_id]
      @intervention.employee_id = params[:administrators_id]
      @intervention.report = params[:description]
      @intervention.result = "Incomplete"
      @intervention.status = "Pending"

      if @intervention.employee_id != nil 

        @employeeaffected = Administrator.find(params[:administrators_id]).first_name 
        @employeeaffected1 = Administrator.find(params[:administrators_id]).last_name 

      end
      

      if @intervention.employee_id == nil

        @employeeaffected = nil
        @employeeaffected1 = nil
      
      end

      

      @zendesk = session[:companyname]

      ZendeskAPI::Ticket.create!($client,

        :subject => "Support from Rocket Elevator", 
        :comment => " Ticket author: #{@intervention.author}.
                      Customer compagny name: #{@zendesk}.
                      Building: #{@intervention.building_id}.
                      Battery: #{@intervention.battery_id}.
                      Column: #{@intervention.column_id}.
                      Elevator: #{@intervention.elevator_id}.
                      Employee affected: #{@employeeaffected} #{@employeeaffected1}
                      Description: #{@intervention.report}",
        :type => "problem"
        
      )

      respond_to do |format|
        if @intervention.save
          format.html { redirect_to "/admin/interventions", notice: 'Intervention was successfully created.' }
          format.json { render :show, status: :created, location: @intervention }
        else
          format.html { redirect_to "/admin/intervention", notice: 'Sorry invalid Intervention, please try again.' }
          format.json { render json: @intervention.errors, status: :unprocessable_entity }
        end
      end
    end
  

    # PATCH/PUT /interventions/1
    # PATCH/PUT /interventions/1.json
    def update
      respond_to do |format|
        if @intervention.update(intervention_params)
          format.html { redirect_to @intervention, notice: 'Intervention was successfully updated.' }
          format.json { render :show, status: :ok, location: @intervention }
        else
          format.html { render :edit }
          format.json { render json: @intervention.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /interventions/1
    # DELETE /interventions/1.json
    def destroy
      @intervention.destroy
      respond_to do |format|
        format.html { redirect_to interventions_url, notice: 'Intervention was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_intervention
        @intervention = Intervention.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def intervention_params
        params.fetch(:intervention, {})
      end
    end

    routes do 
      get :getbuilding
      get :getbattery
      get :getcolumn
      get :getelevator
      post :create
    end
end