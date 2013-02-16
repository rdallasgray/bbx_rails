class Bbx::Controller::DescriptionsController < ApplicationController
  respond_to :json

  def index
    @descriptions = Description.all
    respond_with @descriptions
  end

  def show
    @description = parent_resource ? parent_resource.description : Description.find(params[:id])
    respond_with @description
  end

  def new
    @description = Description.new
    respond_with @description
  end
  
  def create
    @description = parent_resource ? parent_resource.build_description : Description.new
    @description.attributes = params[:description]
    @description.save
    respond_with @description
  end

  def update
    @description = parent_resource ? parent_resource.description : Description.find(params[:id])
    if (@description.nil?)
      @description = parent_resource ? parent_resource.build_description : Description.new
    end
    @description.attributes = params[:description]
    @description.save
    respond_with @description
  end

  def destroy
    @description = parent_resource ? parent_resource.description : Description.find(params[:id])
    @description.destroy
    respond_with @description
  end
end
