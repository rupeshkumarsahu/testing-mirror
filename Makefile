.PHONY: update-secrets

update-secrets:
	@echo "Starting detect-secrets workflow..."

	# Check if detect-secrets is available
	@if command -v detect-secrets >/dev/null 2>&1; then \
		echo "Using existing detect-secrets installation..."; \
		echo "Scanning for secrets and updating baseline..."; \
		detect-secrets scan --update .secrets.baseline --suppress-unscannable-file-warnings; \
	else \
		echo "No detect-secrets found, setting up temporary virtualenv..."; \
		rm -rf .venv-ds; \
		echo "Creating virtualenv .venv-ds..."; \
		python3 -m venv .venv-ds; \
		echo "Upgrading pip..."; \
		.venv-ds/bin/pip install --quiet --upgrade pip; \
		echo "Installing detect-secrets..."; \
		.venv-ds/bin/pip install --quiet git+https://github.com/ibm/detect-secrets.git@master#egg=detect-secrets; \
		echo "Scanning for secrets and updating baseline..."; \
		.venv-ds/bin/detect-secrets scan --update .secrets.baseline --suppress-unscannable-file-warnings; \
		echo "Removing temporary virtualenv..."; \
		rm -rf .venv-ds; \
	fi

	# Remove generated_at field to avoid unnecessary merge conflicts
	@sed -i.bak '/"generated_at":/d' .secrets.baseline && rm -f .secrets.baseline.bak

	@echo "Done! .secrets.baseline updated."
