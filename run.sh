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

# Run training step
mlflow run . -P steps=train_random_forest
# Run training step with varying hyperparameters
# try setting the parameter modeling.max_tfidf_features to 10, 15 and 30, and the modeling.random_forest.max_features to 0.1, 0.33, 0.5, 0.75, 1.
mlflow run . \
  -P steps=train_random_forest \
  -P hydra_options="modeling.random_forest.max_depth=10,50,100 modeling.random_forest.n_estimators=100,200,500 -m"

# Run model test
mlflow run . -P steps=test_regression_model