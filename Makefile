DOCKER_IMAGE = ruby:3.3-slim
DOCKER_SETUP = apt-get update -qq && apt-get install -y -qq build-essential git > /dev/null 2>&1 && cd /srv/jekyll && gem install bundler -q && bundle install
DOCKER_RUN = docker run -e JEKYLL_ENV=production -p 4000:4000 --rm -v=.:/srv/jekyll:Z

serve:
	sudo /usr/bin/rm -rf docs .jekyll-cache .jekyll-metadata
	touch Gemfile.lock
	touch .jekyll-metadata
	mkdir -p docs .jekyll-cache
	chmod a+w Gemfile.lock
	chmod a+w .jekyll-metadata
	chmod a+w docs
	chmod a+w .jekyll-cache
	$(DOCKER_RUN) -it $(DOCKER_IMAGE) sh -c '$(DOCKER_SETUP) && jekyll serve --host 0.0.0.0 --incremental'

serve_and_update:
	rm -f Gemfile.lock
	touch Gemfile.lock
	chmod a+w Gemfile.lock
	$(MAKE) serve

serve_local:
	while :; do bundle exec jekyll serve; done

build:
	$(DOCKER_RUN) $(DOCKER_IMAGE) sh -c '$(DOCKER_SETUP) && jekyll build'

build_local:
	while ! jekyll build; do echo "Trying again ..."; done
