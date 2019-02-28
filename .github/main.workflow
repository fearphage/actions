workflow "Delete branch when pull request is merged" {
  on = "pull_request"
  resolves = "delete branch"
}

action "delete branch" {
  uses = "./github/delete-branch-on-merge"
  secrets = ["GITHUB_TOKEN"]
}

workflow "lint shell scripts" {
  on = "push"
  resolves = "lint scripts"
}

action "lint scripts" {
  uses = "fearphage/shellcheck-action@0.0.3-debug"
  secrets = ["GITHUB_TOKEN"]
}
