#!/usr/bin/env python
"""
Performs basic cleaning on the data and save the results in Weights & Biases
"""
import argparse
import logging
import wandb
import pandas as pd
import os


logging.basicConfig(level=logging.INFO, format="%(asctime)-15s %(message)s")
logger = logging.getLogger()


def go(args):
    """
    Run basic cleaning steps

    argument:
        args : 
            - input_artifact Full name of the input artifact
    return:
        None
    """

    logger.info("Running basic cleaning pipeline step on artifact %s", args.input_artifact)
    
    run = wandb.init(job_type="basic_cleaning")
    run.config.update(args)

    # Download input artifact. This will also log that this script is using this
    # particular version of the artifact
    logger.info("Downloading input artifact")
    artifact_local_path = run.use_artifact(args.input_artifact).file()
    
    logger.info("Loading data into dataframe from CSV (read-only)")
    dataframe = pd.read_csv(artifact_local_path)
    
    # working on a copy keeps the original clean (but uses more memory resources)
    working_dataframe = dataframe.copy(deep=True)
    
    logger.info("Cleaning data: Removing outliers")
    logger.info("Cleaning data: Running data type conversions")
    
    logger.info("Saving created artifact to local CSV")
    working_dataframe.to_csv("clean_sample.csv", index=False)

    logger.info("Saving created artifact to W&B (using wandb)")
    artifact = wandb.Artifact(
        args.output_artifact,
        type=args.output_type,
        description=args.output_description,
    )
    artifact.add_file("clean_sample.csv")
    run.log_artifact(artifact)
    
    logger.info("Clean up local workspace")
    os.remove(artifact_local_path)
    
    logger.info("Cleaning step DONE")
    ######################


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Data cleaning step")

    parser.add_argument(
        "--input_artifact", 
        type=str,
        help="Full name of the input artifact containing the source data",
        required=True
    )

    parser.add_argument(
        "--output_artifact", 
        type=str,
        help="Full name of the output artifact containing cleaned data",
        required=True
    )
    
    parser.add_argument(
        "--output_type", 
        type=str,
        help="Output artifact type",
        required=True
    )
    
    parser.add_argument(
        "--output_description", 
        type=str,
        help="Artifact description",
        required=True
    )
    
    parser.add_argument(
        "--min_price", 
        type=int,
        help="Minimum price (dollars) (values below will be removed, considered outliers)",
        required=True
    )
    
    parser.add_argument(
        "--max_price", 
        type=int,
        help="Maximum price (dollars) (values above will be removed, considered outliers)",
        required=True
    )

    args = parser.parse_args()

    go(args)
