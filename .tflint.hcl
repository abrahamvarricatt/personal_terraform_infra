config {
  module     = true
}

#plugin "aws" {
#  enabled = true
#  deep_check = true
#}


rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}