resource "aws_route53_zone" "spiski" {
  name = "spiski.live"
}

resource "aws_acm_certificate" "spiski" {
  domain_name       = "spiski.live"
  validation_method = "DNS"
}

resource "aws_route53_record" "spiski" {
  for_each = {
  for dvo in aws_acm_certificate.spiski.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.spiski.zone_id
}


resource "aws_acm_certificate_validation" "spiski" {
  certificate_arn         = aws_acm_certificate.spiski.arn
  validation_record_fqdns = [for record in aws_route53_record.spiski : record.fqdn]
}


output "name_servers" {
  value = aws_route53_zone.spiski.name_servers
}

resource "aws_apigatewayv2_domain_name" "spiski" {
  domain_name = "spiski.live"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.spiski.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.spiski]
}

resource "aws_route53_record" "main" {
  name    = aws_apigatewayv2_domain_name.spiski.domain_name
  type    = "A"
  zone_id = aws_route53_zone.spiski.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.spiski.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.spiski.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_api_mapping" "spiski" {
  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.spiski.id
  stage       = aws_apigatewayv2_stage.dev.id
}

resource "aws_apigatewayv2_api_mapping" "query" {
  api_id          = aws_apigatewayv2_api.main.id
  domain_name     = aws_apigatewayv2_domain_name.spiski.id
  stage           = aws_apigatewayv2_stage.dev.id
  api_mapping_key = "q"
}


resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.spiski.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "600"
  records = [aws_apigatewayv2_domain_name.spiski.domain_name]
}

output "custom_domain_index" {
  value = "https://${aws_apigatewayv2_api_mapping.spiski.domain_name}"
}

output "custom_domain_query" {
  value = "https://${aws_apigatewayv2_api_mapping.query.domain_name}/${aws_apigatewayv2_api_mapping.query.api_mapping_key}"
}
