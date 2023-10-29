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

Sources of the **GitOps project's website** (https://josecastillolema.github.io/). Built with [Jekyll](http://jekyllrb.com/) and [Minimal Mistakes theme](https://github.com/mmistakes/minimal-mistakes/) as a static site.

With Gem-based themes, directories such as the `assets`, `_layouts`, `_includes`, and `_sass` are stored in the theme’s gem, hidden from your immediate view. This allows for easier installation and updating as you don’t have to manage any of the theme files. Remote themes are similar to Gem-based themes, but do not require Gemfile changes or whitelisting making them ideal for sites hosted with GitHub Pages.

# Minimal Mistakes remote theme starter

Click [**Use this template**](https://github.com/mmistakes/mm-github-pages-starter/generate) button above for the quickest method of getting started with the [Minimal Mistakes Jekyll theme](https://github.com/mmistakes/minimal-mistakes), replace sample content with your own and [configure as necessary](https://mmistakes.github.io/minimal-mistakes/docs/configuration/).

## Customizations

It is possible to [override the theme defaults](https://jekyllrb.com/docs/themes/#overriding-theme-defaults) with your own customizations:
 - Favicon display
   - [`_includes/head.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/master/_includes/head.html#L18)
 - [Vanilla Back To Top](https://github.com/vfeskov/vanilla-back-to-top)
   - [`_layouts/default.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/master/_layouts/default.html#L21-L25)
 - Master head color
   - [`_sass/minimal-mistakes/_masthead.scss`](https://github.com/josecastillolema/josecastillolema.github.io/blob/master/_sass/minimal-mistakes/_masthead.scss#L14)
   - [`_sass/minimal-mistakes/_navigation.scss`](https://github.com/josecastillolema/josecastillolema.github.io/blob/master/_sass/minimal-mistakes/_navigation.scss#L180)
 - Social icons color
   - [`_sass/minimal-mistakes/_utilities.scss`](https://github.com/josecastillolema/josecastillolema.github.io/blob/master/_sass/minimal-mistakes/_utilities.scss#L328-L340)
 - Remove teasers from search result list
   - [`assets/js/vanilla-back-to-top.min.js`](https://github.com/mmistakes/minimal-mistakes/blob/8a67ce8e41ec850f2d7c373aa47739b2abfee6f1/assets/js/lunr/lunr-en.js#L52-L54)


## Troubleshooting

If you have a question about using Jekyll, start a discussion on the [Jekyll Forum](https://talk.jekyllrb.com/) or [StackOverflow](https://stackoverflow.com/questions/tagged/jekyll). Other resources:

- [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
- [Setting up a Jekyll site with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
- [Configuring GitHub Metadata](https://github.com/jekyll/github-metadata/blob/master/docs/configuration.md#configuration) to work properly when developing locally and avoid `No GitHub API authentication could be found. Some fields may be missing or have incorrect data.` warnings.
