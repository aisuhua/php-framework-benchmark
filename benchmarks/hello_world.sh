#!/bin/sh

bm_name=`basename $0 .sh`
base="http://localhost/php-framework-benchmark"

cd `dirname $0`
cd ..

results="output/results.$bm_name.log"
mv "$results" "$results.old"

benchmark ()
{
    fw="$1"
    url="$2"
    ab_log="output/$fw.ab.log"
    output="output/$fw.output"

    echo $url
    ab -c 10 -n 1000 "$url" > "$ab_log"
    curl "$url" > "$output"
    rps=`grep "Requests per second:" "$ab_log" | cut -f 7 -d " "`
    m=`tail -1 "$output"`
    echo "$fw: $rps: $m" >> "$results"
}

fw="codeigniter-3.0-dev"
url="$base/$fw/index.php/hello/index"
benchmark "$fw" "$url"

fw="yii-2.0"
url="$base/$fw/web/index.php?r=hello/index"
benchmark "$fw" "$url"
