FROM ubuntu:trusty

#config addon
ARG build_dir=/root/build/ofxApp
ENV ADDON_URL https://github.com/armadillu/ofxApp.git

ENV ADDON_BRANCH master
ENV TARGET linux64
ENV OF_BRANCH master
ENV OF_ROOT /root/openFrameworks
ENV TRAVIS_BUILD_DIR $build_dir
ENV NUM_MAKE_THREADS 4
RUN apt-get -y update
RUN apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y update
RUN apt-get -y install nano
RUN apt-get -y install git
RUN apt-get -y install gcc-4.9
RUN apt-get -y install g++-4.9
RUN apt-get -y install gdb
RUN apt-get -y install wget

#clone OF
RUN git clone --depth=1 --branch=$OF_BRANCH https://github.com/openframeworks/openFrameworks $OF_ROOT

#clone addon in build dir
RUN git clone --depth=1 --branch=$ADDON_BRANCH $ADDON_URL $TRAVIS_BUILD_DIR

# RUN $OF_ROOT/scripts/linux/ubuntu/install_dependencies.sh -y
# RUN $OF_ROOT/scripts/ci/$TARGET/install.sh
# RUN $OF_ROOT/scripts/dev/download_libs.sh -a 64;
RUN cd $OF_ROOT
RUN $OF_ROOT/scripts/ci/addons/install.sh

RUN export MAKEFLAGS='-j 4'

RUN $OF_ROOT/scripts/ci/addons/build.sh
