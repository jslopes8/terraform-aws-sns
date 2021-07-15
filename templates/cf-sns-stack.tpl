{
  "AWSTemplateFormatVersion": "2010-09-09",

  "Resources" : {
    "SNSTopic": {
      "Type" : "AWS::SNS::Topic",
      "Properties" : {
        "DisplayName" : "${display_name}",
        "Subscription": [
          {
           "Endpoint" : "${endpoint}",
           "Protocol" : "${protocol}"
          }
        ]
      }
    }
  },

  "Outputs" : {
    "ARN" : {
      "Description" : "SNS Topic ARN",
      "Value" : { "Ref" : "SNSTopic" }
    }
  }
}