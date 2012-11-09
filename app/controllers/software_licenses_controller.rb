class SoftwareLicensesController < ApplicationController
  before_filter :authorize
  before_filter :set_groups, :except => [ :create, :update, :show ]

  def index
    if current_user.admin?
      @licenses = SoftwareLicense.all
    else
      @licenses = SoftwareLicense.any_of({ :group_ids.in => current_user.group_ids }, { :group_ids => [] })
    end
  end

  def grouped
    @group = allowed_groups.where(:name => params[:group]).first
    not_found unless @group
    @licenses = SoftwareLicense.where(:group_ids.in => [@group.id])
    render :template => 'software_licenses/index'
  end

  def new
    @license = SoftwareLicense.new
    @allowed_groups = allowed_groups
  end

  def create
    @license = SoftwareLicense.new(software_license_params)
    @allowed_groups = allowed_groups

    if @license.save
      redirect_to @license, :notice => 'License added'
    else
      render :new
    end
  end

  def show
    @license = SoftwareLicense.find(params[:id])
  end

  def edit
    @license = SoftwareLicense.find(params[:id])
    @allowed_groups = allowed_groups
  end

  def update
    @license = SoftwareLicense.find(params[:id])
    @allowed_groups = allowed_groups

    if @license.update_attributes(software_license_params)
      redirect_to @license, :notice => 'License updated'
    else
      render :edit
    end
  end

  def destroy
    @license = SoftwareLicense.find(params[:id])
    @license.destroy
    redirect_to software_licenses_path, :notice => "License `#{@license.title}' removed"
  end

  private

  def set_groups
    if current_user.admin?
      @groups = Group.all.where(:_id.in => SoftwareLicense.group_ids)
    else
      @groups = current_user.groups.where(:_id.in => SoftwareLicense.group_ids)
    end
  end

  def software_license_params
    params.require(:software_license).permit(
      :title,
      :license_key,
      :licensed_to,
      :comments,
      :group_ids
    ).merge(
      :last_updated_by_ip => request.remote_ip,
      :current_user => current_user
    )
  end
end
