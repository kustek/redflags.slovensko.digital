class SyncRevisionJob < ApplicationJob
  queue_as :default

  def perform(revision)
    return if revision.raw['category_id'] != ENV.fetch('REDFLAGS_PROJECTS_CATEGORY_ID').to_i
    Project.transaction do
      page = revision.page
      project = Project.find_or_create_by!(id: page.id, page_id: page.id)

      project_revision = project.revisions.find_or_initialize_by(revision_id: revision.id)
      project_revision.load_from_data(revision.raw)
      project_revision.save!
    end
  end
end
