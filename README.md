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

The site is generated locally and then the site static files are pushed to GitHub because the site depends on a custom `remote_include` plugin (see below) which is not supported by [GitHub Pages](https://pages.github.com/versions/).

# Chirpy theme

Click [**Use this template**](https://github.com/cotes2020/chirpy-starter/generate) button for the quickest method of getting started with the [Chirpy Jekyll theme](https://github.com/cotes2020/jekyll-theme-chirpy). See the [Chirpy documentation](https://chirpy.cotes.page/) for configuration details.

## Customizations

It is possible to [override the theme defaults](https://jekyllrb.com/docs/themes/#overriding-theme-defaults) with your own customizations:
 - Custom home page with year summary table and year headers
   - [`_layouts/home.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_layouts/home.html)
 - Custom `remote_include` plugin that replaces the archived [`jekyll-remote-include`](https://github.com/netrics/jekyll-remote-include) gem. Fetches raw markdown from GitHub and rewrites relative links to point to the GitHub repository (blob URLs for links, raw URLs for images). Also strips the first `# Title` heading from the fetched content to avoid duplication with the post's own title.
   - [`_plugins/remote_include_rewrite.rb`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_plugins/remote_include_rewrite.rb)
 - Frontmatter `image_link` support (replaces preview image lightbox with custom URL) and `:octocat:` emoji
   - [`_plugins/octocat_emoji.rb`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_plugins/octocat_emoji.rb)
 - Prevent preview image stretching, disable avatar zoom on hover, expand TOC by default, extend TOC to support h5/h6 headings, bold h5/h6 in post content, hide line numbers on shell code blocks and align with plaintext output blocks, merge consecutive output blocks into preceding code blocks (hide header and gap), and hide "Plaintext" label on untagged code blocks
   - [`_includes/metadata-hook.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_includes/metadata-hook.html)
 - TOC support for page layouts (Chirpy only supports TOC on posts by default). Adds TOC panel and mobile popup to pages with `toc: true`.
   - [`_layouts/page.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_layouts/page.html)
   - [`_includes/js-selector.html`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/_includes/js-selector.html)
 - Fix Atom feed icon/logo using absolute URLs so RSS readers (e.g., Feedly) can resolve the favicon. Chirpy's default template uses `site.baseurl` which produces relative paths.
   - [`assets/feed.xml`](https://github.com/josecastillolema/josecastillolema.github.io/blob/main/assets/feed.xml)

## Troubleshooting

If you have a question about using Jekyll, start a discussion on the [Jekyll Forum](https://talk.jekyllrb.com/) or [StackOverflow](https://stackoverflow.com/questions/tagged/jekyll). Other resources:

- [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
- [Setting up a Jekyll site with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
- [Configuring GitHub Metadata](https://github.com/jekyll/github-metadata/blob/master/docs/configuration.md#configuration) to work properly when developing locally and avoid `No GitHub API authentication could be found. Some fields may be missing or have incorrect data.` warnings.
