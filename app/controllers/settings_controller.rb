class SettingsController < ApplicationController
  before_filter :require_admin
  before_filter :require_no_settings_yet, :only => [:new, :create]
  skip_before_filter :require_s3_credentials, :only => [:new, :create]

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(params[:setting].merge({ :url => root_url }))

    if @setting.save
      redirect_to edit_settings_url, :notice => t(:your_changes_were_saved)
    else
      render :action => 'new'
    end
  end

  def edit
    @setting = Setting.instance
  end

  def update
    @setting = Setting.instance

    if @setting.update_attributes(params[:setting])
      redirect_to edit_settings_url, :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  private

  def require_no_settings_yet
    redirect_to edit_settings_url unless Setting.no_s3_settings_yet?
  end
end
