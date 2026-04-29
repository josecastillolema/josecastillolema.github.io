require 'net/http'
require 'uri'

module Jekyll
  class RemoteIncludeRewrite < Liquid::Tag
    def initialize(tag_name, remote_include, tokens)
      super
      @remote_include = remote_include.strip
    end

    def open(url)
      Net::HTTP.get(URI.parse(url)).force_encoding('utf-8')
    end

    def render(context)
      content = open(@remote_include)
      # remove the first h1 heading (may be preceded by badges/blank lines)
      content = content.sub(/^# .+\n+/, '')
      rewrite_relative_urls(content, @remote_include)
    end

    private

    def rewrite_relative_urls(content, raw_url)
      # raw URL format: https://raw.githubusercontent.com/USER/REPO/BRANCH/path/to/FILE
      raw_base = raw_url.sub(%r{/[^/]*$}, '/')

      if raw_url =~ %r{raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/}
        user, repo, branch = $1, $2, $3
        path_after_branch = raw_base.sub(%r{.*raw\.githubusercontent\.com/[^/]+/[^/]+/[^/]+/}, '')
        github_base = "https://github.com/#{user}/#{repo}/blob/#{branch}/#{path_after_branch}"
      else
        github_base = raw_base
      end

      # escape [text]: patterns that aren't reference link definitions
      content = content.gsub(/\[([^\]]+)\]:(?=\s+(?!https?:\/\/))/) do
        "\\[#{Regexp.last_match(1)}\\]:"
      end

      # rewrite images: ![alt](relative) -> raw URL (so they render)
      content = content.gsub(/(!\[[^\]]*\]\()(?!https?:\/\/|#|\/)([^)]+)\)/) do
        prefix = Regexp.last_match(1)
        path = Regexp.last_match(2).sub(%r{^\.\/}, '')
        "#{prefix}#{raw_base}#{path})"
      end

      # rewrite links: [text](relative) -> GitHub blob URL
      content = content.gsub(/(?<!!)(\[[^\]]*\]\()(?!https?:\/\/|#|\/)([^)]+)\)/) do
        prefix = Regexp.last_match(1)
        path = Regexp.last_match(2).sub(%r{^\.\/}, '')
        "#{prefix}#{github_base}#{path})"
      end

      content
    end
  end
end

Liquid::Template.register_tag('remote_include', Jekyll::RemoteIncludeRewrite)

Jekyll::Hooks.register :posts, :post_render do |post|
  post.content = post.content.gsub(/\{%\s*remote_include\s+[^%]*%\}/, '')
  post.output  = post.output.gsub(/\{%\s*remote_include\s+[^%]*%\}/, '') if post.output
end
