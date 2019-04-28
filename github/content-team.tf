locals  {
  content_team_members =  ["bob-ewilde", "sally-ewilde"]
}

// repos
resource "github_repository" "website" {
  name          = "12factor.io"
  description   = "The 12factor.io public website"
  has_issues    = "true"
  has_downloads = "true"
  has_wiki      = "true"
}

resource "github_repository" "documentation" {
  name           = "documentation"
  description    = "company wide awesome documentation"
  default_branch = "master"
}

resource "github_repository" "userguides" {
  name           = "userguides"
  description    = "company wide userguides"
  default_branch = "master"
}

// repo settings
resource "github_branch_protection" "doc" {
  branch = "master"
  repository = "${github_repository.documentation.id}"
  required_pull_request_reviews {
    require_code_owner_reviews = true
  }
}

// teams
resource "github_team" "content" {
  name        = "Content"
  description = "Members of this team manage content within the organisation i.e. documentation, the website ..."
}

// team membership
resource "github_team_membership" "content_team_membership" {
  team_id  = "${github_team.content.id}"
  username = "${local.content_team_members[count.index]}"
  role     = "member"
  count    = "${length(local.content_team_members)}"
}

// team permissions
resource "github_team_repository" "team_repo_documentation" {
  team_id    = "${github_team.content.id}"
  repository = "${github_repository.documentation.name}"
  permission = "push"
}

resource "github_team_repository" "team_repo_webiste" {
  team_id    = "${github_team.content.id}"
  repository = "${github_repository.website.name}"
  permission = "push"
}
