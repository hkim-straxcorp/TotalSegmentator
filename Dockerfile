FROM public.ecr.aws/lambda/python:3.11

COPY requirements.txt ./

RUN yum -y update && yum -y install mesa-libGL git
RUN python3.11 -m pip install -r requirements.txt
RUN python3.11 -m pip uninstall dataclasses -y

COPY utils/aws_s3 utils/aws_s3
COPY utils/aws_sqs utils/aws_sqs
COPY utils/logger utils/logger
COPY utils/bucket_name_gen utils/bucket_name_gen
COPY bmd_utils bmd_utils
COPY lambda_function.py ${LAMBDA_TASK_ROOT}
COPY --from=public.ecr.aws/datadog/lambda-extension:45 /opt/. /opt/
COPY file_io.py ${LAMBDA_TASK_ROOT}
COPY hip_roi.py ${LAMBDA_TASK_ROOT}
COPY project.py ${LAMBDA_TASK_ROOT}
COPY rotate.py ${LAMBDA_TASK_ROOT}
CMD ["datadog_lambda.handler.handler"]