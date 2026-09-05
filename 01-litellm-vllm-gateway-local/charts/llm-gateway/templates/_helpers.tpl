{{/*
Common labels stamped onto every resource in this chart. Defined once here
and pulled in with `include` so every template file stays in sync - this is
the standard reason _helpers.tpl exists in real charts (DRY across templates,
something plain Kustomize resources have to repeat by hand).
*/}}
{{- define "llm-gateway.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: llm-gateway
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}
