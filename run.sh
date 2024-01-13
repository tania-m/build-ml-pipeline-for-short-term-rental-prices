#!/usr/bin/env bash

# Download dataset (step defined in root), stores in W&B as sample.csv
mlflow run . -P steps=download

# Manually run basic cleaning in MLflow with full code source path
# Alternative for Jupyter notebook without MLflow: jupyter-notebook --no-browser
mlflow run src/basic_cleaning -P parameter1=1 -P parameter2=2 -P parameter3="test"

# Run EDA 
mlflow run src/eda