Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |doc|
  if doc.output
    doc.output = doc.output.gsub(":octocat:", '<img class="emoji" title="octocat" alt="octocat" src="https://github.githubassets.com/images/icons/emoji/octocat.png" height="20" width="20">')

    # Replace preview image lightbox link with custom image_link from frontmatter
    if doc.data["image_link"] && doc.data["image"]
      image_src = doc.data["image"].is_a?(Hash) ? doc.data["image"]["path"] : doc.data["image"]
      if image_src
        escaped_src = Regexp.escape(image_src)
        doc.output = doc.output.sub(
          /(<a )href="#{escaped_src}" class="popup (img-link preview-img)/,
          "\\1href=\"#{doc.data["image_link"]}\" target=\"_blank\" rel=\"noopener noreferrer\" class=\"\\2"
        )
      end
    end

    # Remove popup class from shield badge and visitor-badge links to prevent centering/lightbox
    doc.output = doc.output.gsub(/(<a href="https:\/\/img\.shields\.io[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
    doc.output = doc.output.gsub(/(<a href="https:\/\/visitor-badge[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
    doc.output = doc.output.gsub(/(<a href="https:\/\/github-readme-stats\.vercel\.app[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
  end
end
