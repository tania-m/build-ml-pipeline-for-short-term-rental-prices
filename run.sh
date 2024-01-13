#!/usr/bin/env bash

# Download dataset (step defined in root), stores in W&B as sample.csv
mlflow run . -P steps=download

# Run EDA: Pipeline mode
mlflow run src/eda
# Run EDA: Alternative for Jupyter notebook without MLflow: eg. when running on WSL
jupyter-notebook --no-browser

# Manually run download+basic cleaning
mlflow run . -P steps=download,basic_cleaning

# Run only data_check step
mlflow run . -P steps=data_check
