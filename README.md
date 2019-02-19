 # Actions

## delete-branch-on-merge

Deletes branches after they are merged into the default branch.

[Code](https://github.com/fearphage/actions/tree/master/github/delete-branch-on-merge)

### Usage

```
action "delete branch" {
  uses = "fearphage/actions/github/delete-branch-on-merge@master"
  secrets = ["GITHUB_TOKEN"]
}
```

## is-merged

Filter for merged pull requests only.

[Code](https://github.com/fearphage/actions/tree/master/github/is-merged)

### Usage
```
# Filter for merged pull requests
action "Master" {
  uses = "fearphage/actions/github/is-merged@master"
}
```

## Shellcheck (Coming soon)

Posts [Shellcheck](https://github.com/koalaman/shellcheck) results to [github checks api](https://developer.github.com/v3/checks/)
