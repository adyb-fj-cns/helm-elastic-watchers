{{- define "threshold.conditions" }}
{{- $global := index . 0 }}
{{- $values := $global.Values }}
{{- $local := index . 1 }}
"compare": {
  "ctx.payload.hits.total": {
    "gte": {{ $local.threshold }}
  }
}
{{- end }}
