class BroadcastController < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  helper :application

  self.view_paths = "app/views"

  def send_feed(company_id)
    @company_id = company_id
    @job_feed = Job.job_feed(@company_id)
    render('shared/employer/broadcast_job_feed', :formats=>[:js], :layout=>false)
  end

  def opportunities_internal(company_id, js_ids)
    @js_ids = js_ids
    @company_id = company_id
    render('shared/opportunities_internal', :formats=>[:js], :layout=>false)
  end

  def opportunities_normal(js_ids)
    @js_ids = js_ids
    render('shared/opportunities_normal', :formats=>[:js], :layout=>false)
  end

  def employer_dashboard(employer_id, id)
    @employer_id = employer_id
    @id = id
    render('shared/employer_dashboard', :formats=>[:js], :layout=>false)
  end

  def preview_position(job_id)
    @job_id = job_id
    render('shared/preview_position', :formats=>[:js], :layout=>false)
  end

  def detailed_position(job_id)
    @job_id = job_id
    render('shared/detailed_position', :formats=>[:js], :layout=>false)
  end

  def applied_position(job_id)
    @job_id = job_id
    render('shared/applied_position', :formats=>[:js], :layout=>false)
  end

  def purchased_position(company_id, employer_id)
    @company_id = company_id
    @employer_id = employer_id
    render('shared/purchased_position', :formats=>[:js], :layout=>false)
  end

  def candidate_update(job_id)
    @job_id = job_id
    render('shared/candidate_update', :formats=>[:js], :layout=>false)
  end

  def xref_applied(employer_id)
    @employer_id = employer_id
    render('shared/xref_applied', :formats=>[:js], :layout=>false)
  end

  def xref_detailed(employer_id)
    @employer_id = employer_id
    render('shared/xref_detailed', :formats=>[:js], :layout=>false)
  end

  def xref_preview(employer_id)
    @employer_id = employer_id
    render('shared/xref_preview', :formats=>[:js], :layout=>false)
  end

  def xref_update(job_seeker_id, company_id, job_ids)
    @job_seeker_id = job_seeker_id
    @company_id = company_id
    @job_ids = job_ids
    render('shared/xref_update', :formats=>[:js], :layout=>false)
  end

  def dashboard_update(company_id, job_seeker_id)
    @company_id = company_id
    @job_seeker_id = job_seeker_id
    render('shared/dashboard_update', :formats=>[:js], :layout=>false)
  end

  def job_seeker(job_seeker_id)
    @job_seeker_id = job_seeker_id
    render('shared/job_seeker', :formats=>[:js], :layout=>false)
  end

  def employer_update(company_id, page, job_ids, job_seeker_ids = [])
    @company_id = company_id
    @page = page
    @job_ids = job_ids
    @job_seeker_ids = job_seeker_ids
    render('shared/employer_update', :formats=>[:js], :layout=>false)
  end
end