#! /bin/bash
# : Install ROS2 humble

set -x

name_ws="robot_ws"
name_ros2_distro="humble"

echo "[Setup Locales(UTF-8)]"
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "[universe active]"
apt-cache policy | grep universe

echo "[add apt repository and get GPG key]"
sudo apt update && sudo apt install curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt upgrade

echo "[Installing ROS2 humble full]"
sudo apt install -y ros-humble-desktop-full

echo "[Installing ROS2 Tools]"
sudo apt update && sudo apt install -y \
build-essential \
cmake \
git \
libbullet-dev \
python3-colcon-common-extensions \
python3-flake8 \
python3-pip \
python3-pytest-cov \
python3-rosdep \
python3-setuptools \
python3-vcstool \
wget

python3 -m pip install -U \
argcomplete \
flake8-blind-except \
flake8-builtins \
flake8-class-newline \
flake8-comprehensions \
flake8-deprecated \
flake8-docstrings \
flake8-import-order \
flake8-quotes \
pytest-repeat \
pytest-rerunfailures \
pytest

echo "[Make workspace robot_ws]"
source /opt/ros/humble/setup.bash
mkdir -p ~/robot_ws/src
cd ~/robot_ws/
colcon build --symlink-install

echo "[Set ROS2 alias and env]"
sh -c 'echo "alias rh='\''source /opt/ros/humble/setup.bash; source ~/robot_ws/install/local_setup.bash; echo Activate humble!'\''" >> ~/.bashrc'
sh -c "echo \"source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/vcstool-completion/vcs.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/colcon_cd/function/colcon_cd.sh\" >> ~/.bashrc"

sh -c "echo \"export _colcon_cd_root=~/${name_ws}\" >> ~/.bashrc"

sh -c "echo \"export ROS_DOMAIN_ID=7\" >> ~/.bashrc"
sh -c "echo \"export ROS_NAMESPACE=robot1\" >> ~/.bashrc"

sh -c "echo \"export RMW_IMPLEMENTATION=rmw_fastrtps_cpp\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}]: {message}'\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_COLORIZED_OUTPUT=1\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_USE_STDOUT=0\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_BUFFERED_STREAM=1\" >> ~/.bashrc"

sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias gb='gedit ~/.bashrc'\" >> ~/.bashrc"

sh -c "echo \"alias cw='cd ~/robot_ws'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/robot_ws/src'\" >> ~/.bashrc"

sh -c "echo \"alias cb='cd ~/robot_ws && colcon build --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cba='colcon build --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cbp='colcon build --symlink-install --packages-select'\" >> ~/.bashrc"

sh -c "echo \"alias rt='ros2 topic list'\" >> ~/.bashrc"
sh -c "echo \"alias re='ros2 topic echo'\" >> ~/.bashrc"
sh -c "echo \"alias rn='ros2 node list'\" >> ~/.bashrc"

sh -c "echo \"alias killg='killall -9 gazebo & killall -9 gzserver  & killall -9 gzclient'\" >> ~/.bashrc"

sh -c "echo \"alias testpub='ros2 run demo_nodes_cpp talker'\" >> ~/.bashrc"
sh -c "echo \"alias testsub='ros2 run demo_nodes_cpp listener'\" >> ~/.bashrc"


