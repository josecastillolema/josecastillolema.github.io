PODMAN := $(shell command -v podman 2>/dev/null || echo podman-remote)
CONTAINER_IMAGE = docker.io/library/ruby:3.3-slim
CONTAINER_SETUP = apt-get update -qq && apt-get install -y -qq build-essential git > /dev/null 2>&1 && cd /srv/jekyll && gem install bundler -q && bundle install
CONTAINER_RUN = $(PODMAN) run -e JEKYLL_ENV=production -p 4000:4000 --rm -v=$(CURDIR):/srv/jekyll:Z

serve:
	sudo /usr/bin/rm -rf docs .jekyll-cache .jekyll-metadata
	touch Gemfile.lock
	touch .jekyll-metadata
	mkdir -p docs .jekyll-cache
	chmod a+w Gemfile.lock
	chmod a+w .jekyll-metadata
	chmod a+w docs
	chmod a+w .jekyll-cache
	$(CONTAINER_RUN) -it $(CONTAINER_IMAGE) sh -c '$(CONTAINER_SETUP) && jekyll serve --host 0.0.0.0 --incremental'

serve_and_update:
	rm -f Gemfile.lock
	touch Gemfile.lock
	chmod a+w Gemfile.lock
	$(MAKE) serve

serve_local:
	while :; do bundle exec jekyll serve; done

build:
	$(CONTAINER_RUN) $(CONTAINER_IMAGE) sh -c '$(CONTAINER_SETUP) && jekyll build'

build_local:
	while ! jekyll build; do echo "Trying again ..."; done
