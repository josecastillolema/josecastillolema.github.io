prepare:
	touch Gemfile.lock
	mkdir docs
	chmod a+w Gemfile.lock
	chmod a+w _site

serve:
	docker run -e JEKYLL_ENV=production -p 4000:4000 --rm -v=.:/srv/jekyll:Z -it jekyll/builder sh -c 'while :; do jekyll serve; done'

serve_and_update:
	rm Gemfile.lock
	touch Gemfile.lock
	chmod a+w Gemfile.lock
	$(MAKE) serve

serve_local:
	while :; do bundle exec jekyll serve; done

build:
	docker run -e JEKYLL_ENV=production -p 4000:4000 --rm -v=.:/srv/jekyll:Z -it jekyll/builder sh -c 'while ! jekyll build; do echo "Trying again ..."; done'

build_local:
	while ! jekyll build; do echo "Trying again ..."; done
