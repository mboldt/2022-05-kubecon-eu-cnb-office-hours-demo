.PHONY: clean
clean:
	rm -fr app/sbom app/new-sbom
	git checkout app
	docker stop sample-ruby-app || true
