//For creating archieve from content or file or directory of files
data "archive_file" "zip_the_python_code" {
    type = "zip"
    //source_file = "${path.module}/python/hello-world.py"
    source_dir = "${path.module}/nodejs/"
    output_path = "${path.module}/nodejs/nodejs.zip"
}

//Lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
    filename = "${path.module}/nodejs/nodejs.zip"
    function_name = "Terraform-Lambda-2"
    role = "arn:aws:iam::126246811020:role/terraform_aws_lambda_role"
    handler = "hello-world.lambda_handler"
    runtime = "nodejs14.x"
    #depends_on = ["arn:aws:iam::126246811020:policy/aws_iam_policy_for_terraform_aws_lambda_role"]
}