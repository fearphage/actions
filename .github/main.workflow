workflow "Delete branch when pull request is merged" {
  on = "pull_request"
  resolves = "delete branch"
}

action "delete branch" {
  uses = "./github/delete-branch-on-merge"
  secrets = ["GITHUB_TOKEN"]
}
