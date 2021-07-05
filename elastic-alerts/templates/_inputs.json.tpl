{{- define "error.inputs" }}
{{- $global := index . 0 }}
{{- $values := $global.Values }}
{{- $local := index . 1 }}
{{/*
Inline hack to prevent trialing commas in the JSON array
*/}}
{{- $counter := int (sub (len $local.errors) 1) -}}
"search": {
  "request": {
    "search_type": "query_then_fetch",
    "indices": [
      "*"
    ],
    "body": {
      "size": 0,
      "query": {
        "bool": {
          "must": [
            {
              "match_phrase": {
                "kubernetes.deployment.name": "{{ $local.name }}"
              }
            },
            {
              "match_phrase": {
                "kubernetes.namespace": "{{ $values.namespace }}"
              }
            }
          ],
          "should": [
            {{- range $index, $e := until $counter }}
            {
              "match_phrase": {
                "json.message": "{{ index $local.errors $index }}"
              }
            },
            {{- end }}
            {
              "match_phrase": {
                "json.message": "{{ index $local.errors $counter }}"
              }
            }
          ],
          "minimum_should_match": 1,
          "filter": [
            {
              "range": {
                "@timestamp": {
                  "gte": "now-{{ $local.interval }}"
                }
              }
            }
          ]
        }
      }
    }
  }
}
{{- end }}