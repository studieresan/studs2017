class ResumesController < ApplicationController
  before_action :authenticate, except: [:download]

  def show
    resume = User.find(params[:user_id]).resume || User.find(params[:user_id]).build_resume
    return render json: resume
  end

  def update
    resume = User.find(params[:user_id]).resume || User.find(params[:user_id]).build_resume
    if (current_user == resume.user || current_user.has_permission?('user_edit'))
      if resume.update(resume_params)
        return render json: resume
      end
    end

    render json: { error: '' }, status: 403
  end

  def download
    @user = User.find(params[:user_id])
    @resume = @user.resume || @user.build_resume

    # Since WickedPDF is broken and cant be rendered
    view = ActionView::Base.new(Rails.root.join('app/views'))
    view.class.include Rails.application.routes.url_helpers
    pdf = view.render :pdf => "#{ @user.first_name } CV",
                      :template => 'resumes/download',
                      :locals => {user: @user, resume: @resume},
                      :encoding => 'UTF-8'
     pdf = WickedPdf.new.pdf_from_string(pdf)
     return send_data pdf, type: :pdf, disposition: 'inline'
  end

  private
  def resume_params
    params.require(:resume).permit!.except(:id, :user_id)
  end
end
