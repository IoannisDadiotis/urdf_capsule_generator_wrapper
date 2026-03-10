# urdf_capsule_generator_wrapper
Wrapper of open-source code for generating collision capsules for a robot urdf model

## Installation
This setup has been tested on an Ubuntu 24.04 machine with ros2 jazzy installed.
```bash
mkdir -p capsule_ws && cd capsule_ws
git clone --recurse-submodules -j8 git@github.com:IoannisDadiotis/urdf_capsule_generator_wrapper.git
cd urdf_capsule_generator_wrapper
./build_separately.sh
```

## Generate capsules for a URDF model
If everything is built and installed correctly you can run the capsule generation scripts:
```
./source_paths.sh
python3 robot_capsule_urdf your_model.urdf -o output_model.urdf
python3 robot_capsule_urdf_to_rviz output_model.urdf -o output_model_rviz.urdf
```

## Visualize the result
```bash
ros2 run robot_state_publisher robot_state_publisher --ros-args -p robot_description:="$(cat output_model_rviz.urdf)"
```
On two new terminals, open rviz with `rviz2` and a gui for publishing joint states with:
```bash
ros2 run joint_state_publisher_gui joint_state_publisher_gui
```

Remember to visualize a robot model using the ros2 param `/robot_description` and select an existing frame as Fixed frame. If everything has been executed correctly you will be able to see your robot with collision capsules.
<img width="225" height="290" alt="image" src="https://github.com/user-attachments/assets/afeaa7e0-7aef-4a4a-ab17-a67b0d326076" />
