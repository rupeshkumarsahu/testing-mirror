.PHONY: update-secrets

update-secrets:
	@echo "Starting detect-secrets workflow..."

	# Clean any existing virtual environment
	@echo "Cleaning old virtual environment (if any)..."
	@rm -rf .venv-ds

	# Set up a new virtual environment
	@echo "Creating fresh virtual environment at .venv-ds..."
	@python3 -m venv .venv-ds

	# Upgrade pip silently
	@echo "Upgrading pip..."
	@.venv-ds/bin/pip install --upgrade pip > /dev/null

	# Install latest detect-secrets
	@echo "Installing detect-secrets..."
	@.venv-ds/bin/pip install git+https://github.com/ibm/detect-secrets.git@master#egg=detect-secrets > /dev/null

	# Scan and update the baseline
	@echo "Scanning for secrets and updating .secrets.baseline..."
	@.venv-ds/bin/detect-secrets scan --update .secrets.baseline --suppress-unscannable-file-warnings

	@# Remove "generated_at" field to avoid unnecessary merge conflicts
	@sed -i.bak '/"generated_at":/d' .secrets.baseline && rm -f .secrets.baseline.bak

	# Cleanup the virtual environment
	@echo "Removing virtual environment..."
	@rm -rf .venv-ds

	@echo "Done! .secrets.baseline is updated."

