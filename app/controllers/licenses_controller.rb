class LicensesController < ApplicationController
  before_filter :authorize
  before_filter :set_groups, :except => [ :create, :update, :show ]

  def index
    if current_user.admin?
      @licenses = License.all
    else
      @licenses = License.any_of({ :group_ids.in => current_user.group_ids }, { :group_ids => [] })
    end
  end

  def grouped
    @group = allowed_groups.where(:name => params[:group]).first
    not_found unless @group
    @licenses = License.where(:group_ids.in => [@group.id])
    render :template => 'licenses/index'
  end

  def new
    @license = License.new
    @allowed_groups = allowed_groups
  end

  def create
    @license = License.new(license_params)
    @allowed_groups = allowed_groups

    if @license.save
      redirect_to @license, :notice => 'License added'
    else
      render :new
    end
  end

  def show
    @license = License.find(params[:id])
  end

  def edit
    @license = License.find(params[:id])
    @allowed_groups = allowed_groups
  end

  def update
    @license = License.find(params[:id])
    @allowed_groups = allowed_groups

    if @license.update_attributes(license_params)
      redirect_to @license, :notice => 'License updated'
    else
      render :edit
    end
  end

  def destroy
    @license = License.find(params[:id])
    @license.destroy
    redirect_to licenses_path, :notice => "License `#{@license.title}' removed"
  end

  private

  def set_groups
    if current_user.admin?
      @groups = Group.all.where(:_id.in => License.group_ids)
    else
      @groups = current_user.groups.where(:_id.in => License.group_ids)
    end
  end

  def license_params
    params.require(:license).permit(
      :title,
      :license_key,
      :licensed_to,
      :license_file,
      :comments,
      :group_ids
    ).merge(
      :current_user => current_user
    )
  end
end
