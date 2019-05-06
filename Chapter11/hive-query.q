CREATE EXTERNAL TABLE IF NOT EXISTS nasa_logs (
Source STRING,
datefield STRING,
Request STRING,
Status STRING
)

ROW FORMAT SERDE "org.apache.hadoop.hive.serde2.RegexSerDe"
WITH SERDEPROPERTIES(
"input.regex" = "^([^ ]*) - - \\[([^ ]*[\\d]{4})[^ ]* [^ ]* \"([^ ]* [^ ]*) [^ ]* ([\\d]{3}) [^ ]*$",
"output.format.string" = "%1$s %2$s %3$s %4$s"
)

LOCATION '${INPUT}';

INSERT OVERWRITE DIRECTORY '${OUTPUT}'
select datefield, source, request, status, count(*) count
from nasa_logs
where status = "404"
group by datefield, source, request, status;
