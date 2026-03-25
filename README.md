![GitHub](https://img.shields.io/github/license/josecastillolema/josecastillolema.github.io)
![Website](https://img.shields.io/website?url=https%3A%2F%2Fjosecastillolema.github.io)
![Uptime Robot status](https://img.shields.io/uptimerobot/status/m785297761-3cb3eb53ca3a7966274012bc)
![Uptime Robot ratio (30 days)](https://img.shields.io/uptimerobot/ratio/m785297761-3cb3eb53ca3a7966274012bc)
![GitHub language count](https://img.shields.io/github/languages/count/josecastillolema/josecastillolema.github.io)
![GitHub top language](https://img.shields.io/github/languages/top/josecastillolema/josecastillolema.github.io)
![ruby](https://img.shields.io/badge/ruby-3.3-blue)
![jekyll](https://img.shields.io/badge/jekyll-4.4.1-blue)
![bundler](https://img.shields.io/badge/bundler-4.0.8-blue)
![GitHub last commit](https://img.shields.io/github/last-commit/josecastillolema/josecastillolema.github.io)

Sources of the **GitOps project's website** (https://josecastillolema.github.io/). Built with [Jekyll](http://jekyllrb.com/) and [Chirpy theme](https://github.com/cotes2020/jekyll-theme-chirpy) as a static site.

The site is generated locally and then the site static files are pushed to GitHub because the site depends on an [unsupported plugin](https://pages.github.com/versions/), [`jekyll-remote-include`](https://github.com/netrics/jekyll-remote-include).

# Chirpy theme

Click [**Use this template**](https://github.com/cotes2020/chirpy-starter/generate) button for the quickest method of getting started with the [Chirpy Jekyll theme](https://github.com/cotes2020/jekyll-theme-chirpy). See the [Chirpy documentation](https://chirpy.cotes.page/) for configuration details.

## Customizations

It is possible to [override the theme defaults](https://jekyllrb.com/docs/themes/#overriding-theme-defaults) with your own customizations:
 - Custom home page with year summary table and year headers
   - [`_layouts/home.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_layouts/home.html)
 - Frontmatter `image_link` support (replaces preview image lightbox with custom URL) and `:octocat:` emoji
   - [`_plugins/octocat_emoji.rb`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_plugins/octocat_emoji.rb)
 - Prevent preview image stretching and disable avatar zoom on hover
   - [`_includes/metadata-hook.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_includes/metadata-hook.html)

## Troubleshooting

If you have a question about using Jekyll, start a discussion on the [Jekyll Forum](https://talk.jekyllrb.com/) or [StackOverflow](https://stackoverflow.com/questions/tagged/jekyll). Other resources:

- [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
- [Setting up a Jekyll site with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
- [Configuring GitHub Metadata](https://github.com/jekyll/github-metadata/blob/master/docs/configuration.md#configuration) to work properly when developing locally and avoid `No GitHub API authentication could be found. Some fields may be missing or have incorrect data.` warnings.
