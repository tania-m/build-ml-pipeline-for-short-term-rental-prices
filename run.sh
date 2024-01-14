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

# Run data_split step
mlflow run . -P steps=data_split

# Run all steps from download to data_split
mlflow run . -P steps=download,basic_cleaning,data_check,data_split
