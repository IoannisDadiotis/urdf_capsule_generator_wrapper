# Use official ROS 2 Jazzy desktop base image
FROM osrf/ros:jazzy-desktop-full

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    cmake \
    git \
    python3-pip \
    python3-venv \
    python3-setuptools \
    libeigen3-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Ipopt for roboptim
RUN apt-get update && apt-get install -y \
    coinor-libipopt-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install urdf-related ros2 pkgs
RUN apt-get update && apt-get install -y \
    ros-jazzy-urdf \
    ros-jazzy-xacro \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-srdfdom \
    ros-jazzy-joint-state-publisher-gui \
    && rm -rf /var/lib/apt/lists/*

# install moveit
RUN apt-get update && apt-get install -y \
    ros-jazzy-moveit \
    && rm -rf /var/lib/apt/lists/*

# Create workspace directory
WORKDIR /workspace

# Copy your repository into container
COPY . /workspace/urdf_capsule_generator_wrapper

# Set working directory to repo root
WORKDIR /workspace/urdf_capsule_generator_wrapper

# Make scripts executable
RUN chmod +x build_separately.sh source_paths.sh

# Run build script
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && ./build_separately.sh"
# RUN ./build_separately.sh

# Source ROS 2 and your paths for every shell
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /workspace/urdf_capsule_generator_wrapper/source_paths.sh" >> ~/.bashrc

# Default command
CMD ["/bin/bash"]
