serve:
	sudo /usr/bin/rm -rf docs
	touch Gemfile.lock
	touch .jekyll-metadata
	mkdir docs
	chmod a+w Gemfile.lock
	chmod a+w .jekyll-metadata
	chmod a+w docs
	docker run -e JEKYLL_ENV=production -p 4000:4000 --rm -v=.:/srv/jekyll:Z -it jekyll/builder sh -c 'while :; do jekyll serve --incremental; done'

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
