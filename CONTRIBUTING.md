# Contributing

balenaSound was created as a [hack friday](https://www.balena.io/blog/hack-friday-september/) project and has since grown to be a fully featured product with multiple community contributions. If you are interested in contributing to balenaSound this document will help you get started.


## Overview

Make sure you checkout our [architecture][./docs/ARCHITECTURE.md] guide, which aims to explain how all pieces fit together. It's a good starting point for understanding how we designed and built balenaSound. 

Another way to improve how you use and contribute to balenaSound is to take our [masterclasses](https://www.balena.io/docs/learn/more/masterclasses/overview/). Each lesson is a self-contained, deep walk-through on core skills to be successful with your next edge project. Check them out at our [docs](https://www.balena.io/docs/learn/more/masterclasses/overview/).


## Commit guidelines

We enforce certain rules on commits with the following goals in mind:

- Be able to reliably auto-generate the `CHANGELOG.md` *without* any human intervention.
- Be able to automatically and correctly increment the semver version number based on what was done since the last release.
- Be able to get a quick overview of what happened to the project by glancing over the commit history.
- Be able to automatically reference relevant changes from a dependency upgrade.

Our CI will run checks to ensure this guidelines are followed and won't allow merging contributions that don't adhere to them. Version number and changelog are automatically handled by the CI build flow after a pull request is merged. You only need to worry about the commit itself.

## PR guidelines
Pull requests are the only way of pushing your code to the `master` branch. When creating a PR make sure you choose a short but sensical PR title and add a few lines describing your contribution.

### Commit squashing
If your PR contains multiple commits you might be asked to rebase your PR branch on top of the latest `master` and squash your commits before merging. This can be achieved with the following steps, assuming that the current branch is that to be merged to master in your local file system:

```
git checkout master
git pull
git checkout your-branch
git rebase -i master
```

At this point `git rebase` will prompt you to choose an action for each commit and resolve any conflicts. You should `pick` one commit, `reword` it if necessary and `squash` the rest. The reason behind using rebase is that it makes for tidier git branching history. Push the rebased PR branch to the remote and you should be good to go:

```
git push --force-with-lease origin your-branch
```

We strongly encourage using the `--force-with-lease` option instead of `--force` when performing git push to a repository. The reason is that `git push --force` can accidentally overwrite work that has been pushed by a team member in the meantime.
