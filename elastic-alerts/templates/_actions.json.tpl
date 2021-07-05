{{/*
Elastic index action
*/}}
{{- define "index.actions" }}
{{- $global := index . 0 }}
{{- $values := $global.Values }}
{{- $local := index . 1 }}
{{- $service := index . 2 }}
"send_to_elastic": {
  "transform": {
    "script": "return [ \"time\": ctx.trigger.scheduled_time, \"namespace\": \"{{ $values.namespace }}\", \"service\": \"{{ $service.name }}\", \"phrases\": \"PHRASES\", \"interval\": \"{{ $service.interval }}\", \"count\": ctx.payload.hits.total];"
    },
  "index": {
    "index": "{{ $service.name }}-{{ $values.namespace }}-log-alerts-{{ now | date "2006-01-02" }}"
  }
}
{{- end }}

{{/*
Elastic index action
*/}}
{{- define "slack.actions" }}
{{- $global := index . 0 }}
{{- $values := $global.Values }}
{{- $local := index . 1 }}
{{- $service := index . 2 }}
"send_to_slack": {
  "webhook": {
    "scheme": "https",
    "host": "{{ $values.webhook.host }}",
    "port": {{ $values.webhook.port }},
    "method": "{{ $values.webhook.method }}",
    "path": "{{ $values.webhook.path }}",
    "params": {},
    "headers": {
    "Content-type": "application/x-www-form-urlencoded"
    },
    "body": "payload={\"link_names\": \"1\", \"parse\": \"full\" , \"username\": \"{{ $values.namespace }}\", \"text\": \"{{ $service.slack.message}}\", \"attachments\": [{\"blocks\":[{\"type\": \"section\",\"text\": {\"type\": \"mrkdwn\",\"text\": \"<{{ $values.notifications.slack.dashboard.baseUrl}}/{{ $service.slack.dashboard.urlPath}}|{{ $service.slack.dashboard.linkText}}>\"}}]}], \"icon_emoji\": \"EMOJI_ICON\"}"
  }
}
{{- end }}