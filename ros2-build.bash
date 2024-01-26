now_dir=$(pwd)
cd ~/ros2-cv

clear
if [ "$1" == "-r" ]; then
    rm -rf build/ log/ install/
fi

colcon build \
  --symlink-install \
  --event-handlers console_direct+ \
  --cmake-args \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=/usr/local/bin/gcc \
    -DCMAKE_CXX_COMPILER=/usr/local/bin/g++ \
  --packages-skip tester time_watcher \
  --parallel-workers 16 \

cd $now_dir


    # -DCMAKE_C_COMPILER=/usr/local/bin/gcc \
    # -DCMAKE_CXX_COMPILER=/usr/local/bin/g++ \
    # -DCMAKE_CUDA_FLAGS="-allow-unsupported-compiler" \


# socat -d -d pty,raw,echo=0 pty,raw,echo=0
# ros2 launch rm_aim_launch auto_aim.launch.py