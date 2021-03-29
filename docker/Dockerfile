ARG ROS_DISTRO=melodic
FROM ros:$ROS_DISTRO-ros-core
ARG PYTHON_VERSION=
LABEL Name="ROS Node Example"
LABEL Version="0.1"

# Make the user and group consistent and known.
ARG USER_ID=1004
ARG GROUP_ID=1000

# Run the following commands as the root user.
USER root

# Update PATH to include local pip installs.
ENV PATH="/home/ros/.local/bin:${PATH}"

# Workaround for sudo bug on Ubuntu Focal.
# https://unix.stackexchange.com/questions/578949/sudo-setrlimitrlimit-core-operation-not-permitted
# https://github.com/sudo-project/sudo/issues/42
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# Packages needed for various utility steps.
RUN apt-get update && apt-get install -y \
    build-essential curl file git locales sudo && \
    apt-get clean

# Set up the locale.
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8

# Statick npm tools.
# Have to install newer version from non-apt source due to SSL library compatibility issues.
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get update && apt-get install -y nodejs && apt-get clean
RUN npm config set prefix -g /usr
RUN npm install -g markdownlint-cli@0.21.0

# Build and static analysis tools.
RUN apt-get update && apt-get install -y \
    bandit \
    cccc \
    clang \
    clang-6.0 \
    clang-format \
    clang-format-6.0 \
    clang-tidy \
    clang-tidy-6.0 \
    cmake \
    cppcheck \
    findbugs \
    flawfinder \
    libomp-dev \
    libpcre3-dev \
    libxml2 \
    libxml2-utils \
    pyflakes \
    pylint \
    python$PYTHON_VERSION-catkin-lint \
    python$PYTHON_VERSION-git \
    python$PYTHON_VERSION-pip \
    python$PYTHON_VERSION-rosdep \
    python$PYTHON_VERSION-vcstools \
    python$PYTHON_VERSION-wstool \
    python3-pep8 \
    python3-setuptools \
    python3-vcstools \
    python3-yaml \
    python3-yapsy \
    ros-$ROS_DISTRO-roslint \
    uncrustify \
    python-catkin-tools && \
    apt-get clean

# Need to initialize rosdep as root.
RUN rosdep init

# Regular user setup.
RUN groupadd -g $GROUP_ID ros && \
    useradd -m ros -s /bin/bash -u $USER_ID -g ros -d /home/ros

# Allow passwordless sudo.
RUN echo "ros ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ros && \
    chmod 0440 /etc/sudoers.d/ros

# Switch to regular user.
USER ros

# Get latest rosdep sources.
RUN rosdep update

# Make a workspace directory that can be mounted as a volume from the host system.
# This approach is taken so that the actual packages to build reside on the host system where the users preferred
# development tools can be used when editing files.
RUN mkdir -p /home/ros/ws/src

RUN cd /home/ros/ws/src

RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash"
    # Update apt-get because its cache is always cleared after installs to keep image size down

RUN sudo git clone https://github.com/aniket15b/node_example.git 

RUN cd /home/ros/ws \
    # Build catkin workspace
    && catkin build

RUN echo "source /ros_catkin_entrypoint.sh" >> /root/.bashrc

COPY ./ros_catkin_entrypoint.sh /
RUN chmod +x /ros_catkin_entrypoint.sh

ENTRYPOINT ["/ros_catkin_entrypoint.sh"]
CMD ["bash"]
