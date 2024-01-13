#!/usr/bin/env bash

# Download dataset (step defined in root), stores in W&B as sample.csv
mlflow run . -P steps=download

# Run EDA: Pipeline mode
mlflow run src/eda
# Run EDA: Alternative for Jupyter notebook without MLflow: eg. when running on WSL
jupyter-notebook --no-browser

# Manually run basic cleaning in MLflow with full code source path
mlflow run src/basic_cleaning -P input_artifact=1 etc...
