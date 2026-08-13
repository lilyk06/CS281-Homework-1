PYTHON := python3
VENV := .venv
VENV_PYTHON := $(VENV)/bin/python
VENV_PIP := $(VENV)/bin/pip
DEMO := demo.py

.PHONY: help setup run clean info

help:
	@echo ""
	@echo "DGL HW7 - CPU vs GPU Demo"
	@echo ""
	@echo "Available commands:"
	@echo "  make setup   Create virtual environment and install dependencies"
	@echo "  make run     Run the CPU vs GPU matrix multiplication demo"
	@echo "  make info    Show Python and PyTorch GPU information"
	@echo "  make clean   Remove the virtual environment"
	@echo ""

setup: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install -r requirements.txt
	@touch $(VENV)/bin/activate
	@echo ""
	@echo "Setup complete."
	@echo "Run the demo with:"
	@echo "  make run"

run: setup
	$(VENV_PYTHON) $(DEMO)

info: setup
	@$(VENV_PYTHON) -c "import torch; \
	print('PyTorch:', torch.__version__); \
	print('CUDA available:', torch.cuda.is_available()); \
	print('ROCm/HIP:', torch.version.hip); \
	print('MPS available:', hasattr(torch.backends, 'mps') and torch.backends.mps.is_available())"

clean:
	rm -rf $(VENV)
	@echo "Virtual environment removed."