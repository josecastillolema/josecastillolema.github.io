Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |doc|
  if doc.output
    doc.output = doc.output.gsub(":octocat:", '<img class="emoji" title="octocat" alt="octocat" src="https://github.githubassets.com/images/icons/emoji/octocat.png" height="20" width="20">')

    # Remove popup class from shield badge and visitor-badge links to prevent centering/lightbox
    doc.output = doc.output.gsub(/(<a href="https:\/\/img\.shields\.io[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
    doc.output = doc.output.gsub(/(<a href="https:\/\/visitor-badge[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
    doc.output = doc.output.gsub(/(<a href="https:\/\/github-readme-stats\.vercel\.app[^"]*" class=")popup (img-link shimmer")/) { "#{$1}#{$2}" }
  end
end
