![GitHub](https://img.shields.io/github/license/josecastillolema/josecastillolema.github.io)
![Website](https://img.shields.io/website?url=https%3A%2F%2Fjosecastillolema.github.io)
![Uptime Robot status](https://img.shields.io/uptimerobot/status/m785297761-3cb3eb53ca3a7966274012bc)
![Uptime Robot ratio (30 days)](https://img.shields.io/uptimerobot/ratio/m785297761-3cb3eb53ca3a7966274012bc)
![GitHub language count](https://img.shields.io/github/languages/count/josecastillolema/josecastillolema.github.io)
![GitHub top language](https://img.shields.io/github/languages/top/josecastillolema/josecastillolema.github.io)
![gem](https://img.shields.io/badge/gem-3.1.2-blue)
![ruby](https://img.shields.io/badge/ruby-2.7-blue)
![jekyll](https://img.shields.io/badge/jekyll-3.8.7-blue)
![bundler](https://img.shields.io/badge/bundler-2.1.4-blue)
![GitHub last commit](https://img.shields.io/github/last-commit/josecastillolema/josecastillolema.github.io)
![Security Headers](https://img.shields.io/security-headers?url=https%3A%2F%2Fjosecastillolema.github.io)
![Chromium HSTS preload](https://img.shields.io/hsts/preload/josecastillolema.github.io)
![Mozilla HTTP Observatory Grade](https://img.shields.io/mozilla-observatory/grade/josecastillolema.github.io?publish)
![Snyk Vulnerabilities for GitHub Repo](https://img.shields.io/snyk/vulnerabilities/github/josecastillolema/josecastillolema.github.io?publish)
![Jekyll site CI](https://github.com/josecastillolema/josecastillolema.github.io/workflows/Jekyll%20site%20CI/badge.svg)


Sources of the **GitOps project's website** (https://josecastillolema.github.io/).

It is built with [Jekyll](http://jekyllrb.com/) as a static site.
The `master` branch contains only the generated files, ie what is in the `_site`.

To update the website, proceed like this:

* Make changes in the `source` branch.
* Build the site with Jekyll and test it locally.
* Commit your changes.
* Run `make publish`

This is the commands that are run when you type `make publish`:

```
git branch -D master
git checkout -b master
git filter-branch --subdirectory-filter _site/ -f
git checkout source
git push --all origin
```

The idea behind this process is from [@randymorris](https://github.com/randymorris)
(see [this](https://github.com/randymorris/randymorris.github.com/blob/source/README.md)).
