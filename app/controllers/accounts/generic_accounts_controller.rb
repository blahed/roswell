class Accounts::GenericAccountsController < ApplicationController
  before_filter :authorize
  before_filter :set_groups, :except => [ :create, :update, :show ]

  def index
    if current_user.admin
      @accounts = GenericAccount.all
    else
      @accounts = GenericAccount.any_of({ :group_ids.in => current_user.group_ids }, { :group_ids => [] })
    end
  end

  def grouped
    @group = allowed_groups.where(:name => params[:group]).first
    not_found unless @group
    @accounts = GenericAccount.where(:group_ids.in => [@group.id])
    render :template => 'accounts/generic_accounts/index'
  end

  def new
    @account = GenericAccount.new
    @allowed_groups = allowed_groups
  end

  def create
    @account = GenericAccount.new(account_params)
    @allowed_groups = allowed_groups

    if @account.save
      redirect_to [ :accounts, @account ], :notice => 'Account created'
    else
      render :new
    end
  end

  def show
    @account = GenericAccount.find(params[:id])
  end

  def edit
    @account = GenericAccount.find(params[:id])
    @allowed_groups = allowed_groups
  end

  def update
    @account = GenericAccount.find(params[:id])
    @allowed_groups = allowed_groups

    if @account.update_attributes(account_params)
      redirect_to [ :accounts, @account ], :notice => 'Account updated'
    else
      render :edit
    end
  end

  def destroy
    @account = GenericAccount.find(params[:id])
    @account.destroy
    redirect_to accounts_generic_accounts_path, :notice => "Account `#{@account.title}' removed"
  end

  private

  def set_groups
    if current_user.admin?
      @groups = Group.all.where(:_id.in => GenericAccount.group_ids)
    else
      @groups = current_user.groups.where(:_id.in => GenericAccount.group_ids)
    end
  end

  def account_params
    params.require(:generic_account).permit(
      :title,
      :username,
      :password,
      :license_file,
      :comments,
      :group_ids
    ).merge(
      :current_user => current_user
    )
  end
end
