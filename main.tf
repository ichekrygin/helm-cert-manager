locals {
  crds-url = "https://raw.githubusercontent.com/jetstack/cert-manager/${var.crd-release}/deploy/manifests/00-crds.yaml"
}

provider http {}

data http crds {
  url = local.crds-url
}

resource null_resource cert-manager-crds {
  triggers = {
    build = sha1(data.http.crds.body)
  }
  provisioner local-exec {
    command = "${var.kubectl-cmd} apply -f ${local.crds-url} --validate=false"
  }
}

data helm_repository cert-manager {
  name = var.chart-repo-name
  url  = var.chart-repo-url
}

resource helm_release cert-manager {
  depends_on = [null_resource.cert-manager-crds]
  repository = data.helm_repository.cert-manager.metadata.0.name
  chart      = var.chart-name
  version    = var.chart-version
  name       = var.chart-release
  namespace  = var.chart-namespace
  wait       = true

  dynamic set {
    for_each = var.global-imagePullSecrets
    content {
      name  = "global.imagePullSecrets[${set.key}]"
      value = set.value
    }
  }
  set {
    name  = "global.rbac.create"
    value = var.global-rbac-create
  }
  set {
    name  = "global.priorityClassName"
    value = var.global-priorityClassName
  }
  set {
    name  = "global.podSecurityPolicy.enabled"
    value = var.global-podSecurityPolicy-enabled
  }
  set {
    name  = "global.leaderElection.namespace"
    value = var.global-leaderElection-namespace
  }
  set {
    name  = "image.repository"
    value = var.image-repository
  }
  set {
    name  = "image.tag"
    value = var.image-tag
  }
  set {
    name  = "image.pullPolicy"
    value = var.image-pullPolicy
  }
  set {
    name  = "replicaCount"
    value = var.replicaCount
  }
  set {
    name  = "clusterResourceNamespace"
    value = var.clusterResourceNamespace
  }
  dynamic set {
    for_each = {
      for key, value in var.extraArgs :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "extraArgs.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "serviceAccount.create"
    value = var.serviceAccount-create
  }
  set {
    name  = "serviceAccount.name"
    value = var.serviceAccount-name
  }
  dynamic set {
    for_each = {
      for key, value in var.serviceAccount-annotations :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "serviceAccount.annotations.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "ingressShim.defaultIssuerName"
    value = var.ingressShim-defaultIssuerName
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = var.ingressShim-defaultIssuerKind
  }
  set {
    name  = "prometheus.enabled"
    value = var.prometheus-enabled
  }
  set {
    name  = "prometheus.servicemonitor.enabled"
    value = var.prometheus-servicemonitor-enabled
  }
  set {
    name  = "prometheus.servicemonitor.namespace"
    value = var.prometheus-servicemonitor-namespace
  }
  set {
    name  = "prometheus.servicemonitor.prometheusInstance"
    value = var.prometheus-servicemonitor-prometheusInstance
  }
  set {
    name  = "prometheus.servicemonitor.targetPort"
    value = var.prometheus-servicemonitor-targetPort
  }
  set {
    name  = "prometheus.servicemonitor.path"
    value = var.prometheus-servicemonitor-path
  }
  set {
    name  = "prometheus.servicemonitor.interval"
    value = var.prometheus-servicemonitor-interval
  }
  dynamic set {
    for_each = {
      for key, value in var.prometheus-servicemonitor-labels :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "prometheus.servicemonitor.labels.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "prometheus.servicemonitor.scrapeTimeout"
    value = var.prometheus-servicemonitor-scrapeTimeout
  }
  dynamic set {
    for_each = {
      for key, value in var.podAnnotations :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "podAnnotation.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "podDnsPolicy"
    value = var.podDnsPolicy
  }
  dynamic set {
    for_each = {
      for key, value in var.podLabels :
      replace(key, ".", "\n") => value
    }
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "http_proxy"
    value = var.http-proxy
  }
  set {
    name  = "https_proxy"
    value = var.https-proxy
  }
  set {
    name  = "no_proxy"
    value = var.no-proxy
  }
  set {
    name  = "webhook.enabled"
    value = var.webhook-enabled
  }
  set {
    name  = "webhook.replicaCount"
    value = var.webhook-replicaCount
  }
  dynamic set {
    for_each = {
      for key, value in var.webhook-podAnnotations :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "webhook.podAnnotations.${set.key}"
      value = set.value
    }
  }
  set {
    name  = "webhook.image.repository"
    value = var.webhook-image-repository
  }
  set {
    name  = "webhook.image.tag"
    value = var.webhook-image-tag
  }
  set {
    name  = "webhook.image.pullPolicy"
    value = var.webhook-image-pullPolicy
  }
  set {
    name  = "webhook.injectAPIServerCA"
    value = var.webhook-injectAPIServerCA
  }
  set {
    name  = "cainjector.enabled"
    value = var.cainjector-enabled
  }
  set {
    name  = "cainjector.replicaCount"
    value = var.cainjector-replicaCount
  }
  dynamic set {
    for_each = {
      for key, value in var.cainjector-podAnnotations :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "cainjector.podAnnotations.${set.key}"
      value = set.value
    }
  }
  dynamic set {
    for_each = {
      for key, value in var.cainjector-extraArgs :
      replace(key, ".", "\\.") => value
    }
    content {
      name  = "cainjector.extraArgs.${set.key}"
      value = ""
    }
  }
  set {
    name  = "cainjector.image.repository"
    value = var.cainjector-image-repository
  }
  set {
    name  = "cainjector.image.tag"
    value = var.cainjector-image-tag
  }
  set {
    name  = "cainjector.image.pullPolicy"
    value = var.cainjector-image-pullPolicy
  }

  values = [
    <<EOF
extraEnv: ${indent(2, "\n${var.extraEnv}")}
nodeSelector: ${indent(2, "\n${var.nodeSelector}")}
affinity: ${indent(2, "\n${var.affinity}")}
tolerations: ${indent(2, "\n${var.tolerations}")}
podDnsConfig: ${indent(2, "\n${var.podDnsConfig}")}
webhook.resources: ${indent(4, "\n${var.webhook-resources}")}
webhook.nodeSelector: ${indent(4, "\n${var.webhook-nodeSelector}")}
webhook.affinity: ${indent(4, "\n${var.webhook-affinity}")}
webhook.tolerations: ${indent(4, "\n${var.webhook-tolerations}")}
cainjector.resources: ${indent(4, "\n${var.cainjector-resources}")}
cainjector.nodeSelector: ${indent(4, "\n${var.cainjector-nodeSelector}")}
cainjector.affinity: ${indent(4, "\n${var.cainjector-affinity}")}
cainjector.tolerations: ${indent(4, "\n${var.cainjector-tolerations}")}
EOF
  ]
}
