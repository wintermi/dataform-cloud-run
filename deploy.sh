#!/bin/bash

# Copyright © 2024 Matthew Winter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PROJECT_ID=$(gcloud config get project)
export REGION=${REGION:=us-central1}

JOB_NAME="dataform-cloud-run"
REPOSITORY="core"
IMAGE_NAME=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/${JOB_NAME}
NUM_TASKS=1

echo "Configure gcloud to use ${REGION} for Cloud Run"
gcloud config set run/region ${REGION}

echo "Enabling required services"
gcloud services enable \
    run.googleapis.com

# Delete job if it already exists.
echo "Deleting ${JOB_NAME}"
gcloud run jobs delete ${JOB_NAME} --region=${REGION} --project=${PROJECT_ID} --quiet

echo "Creating ${JOB_NAME} using ${IMAGE_NAME}"
gcloud run jobs create ${JOB_NAME} \
    --image ${IMAGE_NAME} \
    --tasks ${NUM_TASKS} \
    --max-retries 1 \
    --cpu=1 \
    --memory=2Gi \
    --region=${REGION} \
    --project=${PROJECT_ID}
