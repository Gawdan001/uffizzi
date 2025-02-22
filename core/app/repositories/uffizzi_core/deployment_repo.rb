# frozen_string_literal: true

module UffizziCore::DeploymentRepo
  extend ActiveSupport::Concern

  included do
    scope :with_name, ->(name) {
      where(name: name)
    }
    scope :with_amazon_repos, -> { includes(containers: [:repo]).where(containers: { repos: { type: UffizziCore::Repo::Amazon.name } }) }
    scope :enabled, -> { where(state: [:active, :failed]) }
    scope :active_for_credential_id, ->(credential_id) {
      active.joins(project: :credentials).merge(UffizziCore::Project.active).where(credentials: { id: credential_id })
    }

    scope :with_labels, ->(labels) {
      where("#{UffizziCore::Deployment.table_name}.metadata @> ?", labels.to_json)
    }
  end
end
