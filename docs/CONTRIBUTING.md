# Contributing

balenaSound was created as a [hack friday](https://www.balena.io/blog/hack-friday-september/) project and has since grown to be a fully featured product with multiple community contributions. If you are interested in contributing to balenaSound this document will help you get started.

## Semantic versioning and commit messages

The balenaSound version numbering adheres to [Semantic Versioning](http://semver.org/). The following
header/row is required in the body of a commit message, and will cause the CI build to fail if absent:

```
Change-type: patch|minor|major
```

Version numbers and commit messages are automatically added to the `CHANGELOG.md` file by the CI
build flow, after a pull request is merged. It should not be manually edited.
