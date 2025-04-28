# Start from an official Python base image
FROM python:3.11-slim-bookworm

# Install git and clean up apt cache in the same layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory in the container
WORKDIR /workspace

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies - combine commands to reduce layers
RUN pip install --no-cache-dir \
    jupyterlab \
    jupyterlab-git \
    httpx==0.27.2 \
    -r requirements.txt

# Copy the entire project
COPY . .

# Expose the port Jupyter will run on
EXPOSE 8888

# Start Jupyter Lab from the cancer_prediction directory
WORKDIR /workspace/cancer-prediction
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--LabApp.token=''", "--LabApp.password=''"]