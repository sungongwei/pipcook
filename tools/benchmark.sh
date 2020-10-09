t1=$(date +%s)
npm install
t2=$(date +%s)
install_time=$((t2-t1))

t1=$(date +%s)
npm run dev-build
t2=$(date +%s)
esbuild_time=$((t2-t1))

t1=$(date +%s)
npm run build
t2=$(date +%s)
build_time=$((t2-t1))

t1=$(date +%s)
./packages/cli/dist/bin/pipcook init
t2=$(date +%s)
init_time=$((t2-t1))

./packages/cli/dist/bin/pipcook daemon start
t1=$(date +%s)
npm run test
t2=$(date +%s)
test_time=$((t2-t1))

t1=$(date +%s)
./packages/cli/dist/bin/pipcook run ./example/pipelines/mnist-image-classification.json
t2=$(date +%s)
mnist_time=$((t2-t1))

git clone https://github.com/imgcook/pipcook-benchmark.git
cd pipcook-benchmark

echo $(cat data.json | 
          jq --arg install_time $install_time \
            --arg esbuild_time $esbuild_time \
            --arg build_time $build_time \
            --arg init_time $init_time \
            --arg test_time $test_time \
            --arg time_stamp $(date +%s) \
            --arg mnist_time $mnist_time \
            '. + [{install_time:$install_time, init_time:$init_time, esbuild_time:$esbuild_time, build_time:$build_time, test_time:$test_time, mnist_time:$mnist_time, timestamp: $time_stamp }]')  > data.json

git config user.email "eric.lwh@alibaba-inc.com"
git config user.name "WenheLI"
git add data.json
git commit --allow-empty  -am"[circleci]: update data"
git push -q https://${TOKEN}@github.com/imgcook/pipcook-benchmark.git
