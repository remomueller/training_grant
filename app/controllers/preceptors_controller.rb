class PreceptorsController < ApplicationController
  before_filter :authenticate_user!

  def index
    # current_user.update_attribute :preceptors_per_page, params[:preceptors_per_page].to_i if params[:preceptors_per_page].to_i >= 10 and params[:preceptors_per_page].to_i <= 200
    preceptor_scope = Preceptor.current # current_user.all_viewable_preceptors
    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| preceptor_scope = preceptor_scope.search(search_term) }

    @order = Preceptor.column_names.collect{|column_name| "preceptors.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "preceptors.last_name"
    preceptor_scope = preceptor_scope.order(@order)

    @preceptors = preceptor_scope.page(params[:page]).per( 40 ) #current_user.preceptors_per_page)
  end

  # GET /preceptors/1
  # GET /preceptors/1.json
  def show
    @preceptor = Preceptor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @preceptor }
    end
  end

  # GET /preceptors/new
  # GET /preceptors/new.json
  def new
    @preceptor = Preceptor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @preceptor }
    end
  end

  # GET /preceptors/1/edit
  def edit
    @preceptor = Preceptor.find(params[:id])
  end

  # POST /preceptors
  # POST /preceptors.json
  def create
    @preceptor = Preceptor.new(params[:preceptor])

    respond_to do |format|
      if @preceptor.save
        format.html { redirect_to @preceptor, notice: 'Preceptor was successfully created.' }
        format.json { render json: @preceptor, status: :created, location: @preceptor }
      else
        format.html { render action: "new" }
        format.json { render json: @preceptor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /preceptors/1
  # PUT /preceptors/1.json
  def update
    @preceptor = Preceptor.find(params[:id])

    respond_to do |format|
      if @preceptor.update_attributes(params[:preceptor])
        format.html { redirect_to @preceptor, notice: 'Preceptor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @preceptor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preceptors/1
  # DELETE /preceptors/1.json
  def destroy
    @preceptor = Preceptor.find(params[:id])
    @preceptor.destroy

    respond_to do |format|
      format.html { redirect_to preceptors_url }
      format.json { head :no_content }
    end
  end
end
