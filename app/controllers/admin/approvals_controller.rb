class Admin::ApprovalsController < Admin::BaseController

  def index
    authorize! :read, ApprovalBox
    @approval_boxes = ApprovalBox.all
  end

  def update
    approval_box = ApprovalBox.find params[:id]
    authorize! :manage, approval_box

    if approval_box.update_attributes(box_params)
      approval_box.user.update_attributes(role: User::ROLES[:master])
      CoreNotification.create(message: "#{approval_box.user.name} is Master from now!")
      flash.notice = "#{approval_box.user.name} Master request approved."
      approval_box.destroy
    else
      flash.alert = "#{approval_box.user.name} Master request declined"
    end

    redirect_to admin_approvals_path
  end

  def destroy
    approval_box = ApprovalBox.find params[:id]
    authorize! :manage, approval_box

    message = "#{approval_box.user.name} Master request declined."
    approval_box.destroy
    approval_box.user.update_attributes(want_to_be_master: false)
    CoreNotification.create(message: message)
    redirect_to admin_approvals_path
  end

  private

  def box_params
    params.require(:approval_box).permit(:approved)
  end
end
