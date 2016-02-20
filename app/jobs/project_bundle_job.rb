class ProjectBundleJob < ActiveJob::Base
  queue_as :default

  def perform(project_bundle)
    project = project_bundle.project
    project.with_lock('FOR SHARE') do
      @old_working_directory = Dir.pwd
      @working_directory = Dir.mktmpdir 'project_bundle'
      Dir.chdir @working_directory
      submissions_directory_path = File.join(
        Dir.pwd, 'submissions'
      )
      Dir.mkdir submissions_directory_path
      Dir.chdir submissions_directory_path
      Submission.newest_per_submitter_of_project(project_bundle.project).each do |submission|
        IO.binwrite(submission.solution.generate_file_name, submission.solution.code)
      end
      Dir.chdir @working_directory
      `tar -czf submissions.tar.gz submissions`
      raise TarError, "Project bundle #{project_bundle.id}" if $CHILD_STATUS.exitstatus != 0
      project_bundle.data = File.binread 'submissions.tar.gz'
      project_bundle.save!
      Dir.chdir @old_working_directory
      FileUtils.remove_entry_secure @working_directory
    end
    UserMailer.project_bundle(project_bundle.user, project_bundle).deliver_now
    delay = Rails.application.config.configurations[:project_bundle_life_hours]
    unless Rails.env.test?
      DestroyProjectBundleJob.set(wait: delay.hours).perform_later(project_bundle)
    end
    project.notify_bundle_ready(project_bundle)
  end
end
