{{- define "interval.triggers" }}
{{- $global := index . 0 }}
{{- $values := $global.Values }}
{{- $local := index . 1 }}
"schedule": {
  "interval": "{{ $local.interval }}"
}
{{- end }}